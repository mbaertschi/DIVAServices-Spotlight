# Poller
# ======
#
# **Poller** is responsible for polling information from hosts stored in mongoDB.
# The polling interval is specified in `./web/conf/server.[dev/prod].json`. Each
# polling iteration fetches all information which are then passed to parser for
# validation. Valid algorithms are stored or updated in mongoDB. Invalid algorithms
# are removed. All changes are passed on to clients by the pusher.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
logger      = require './logger'
async       = require 'async'
nconf       = require 'nconf'
loader      = require './loader'
parser      = require './parser'
_           = require 'lodash'
mongoose    = require 'mongoose'
moment      = require 'moment'

# Expose poller
poller = exports = module.exports = class Poller

  # ---
  # **constructor**</br>
  # Assign mongoDB and pusher</br>
  # `params:`
  #   * *db* `<Mongoose>` the mongoose instance to store information in
  #   * *pusher* `<Pusher>` the pusher instance to use for realtime communication
  constructor: (db, pusher) ->
    logger.log 'info', 'initializing', 'Poller'
    @db = db
    @Algorithm = mongoose.model 'Algorithm'
    if (nconf.get 'pusher:run') then @pusher = pusher

  # ---
  # **run**</br>
  # Start poller
  run: =>
    async.forever @_nextIteration, (err) ->
      logger.log 'error', "something went wrong... going to shutdown! #{err}", 'Poller'
      setTimeout (-> process.exit(0)), 2000

  # ---
  # **_nextIteration**</br>
  # Main entrance for polling ceycle. Interval is specified in `./web/conf/server.[dev/prod].json`.
  # Following tasks are executed in every iteration:</br>
  # 1. *load hosts* stored in mongoDB
  # 2. *load algorithms* iterate over all hosts and load all algorithms for the currently processed host
  # 3. *compare and store* all algorithms fetched from hosts
  # 4. *remove* all invalid algorithms
  # 5. *push* all changes to clients
  _nextIteration: (callback) =>
    logger.log 'info', 'next iteration', 'Poller'
    async.waterfall [(next) =>
        @_loadHosts next
      , (hosts, next) =>
        @_loadAlgorithms hosts, next
      , (algorithms, next) =>
        @_compareAndStoreAlgorithms algorithms, next
      , (algorithms, changedAlgorithms, addedAlgorithms, next) =>
        @_removeInvalidAlgorithms algorithms, (err, removedAlgorithms) =>
          next err, changedAlgorithms, addedAlgorithms, removedAlgorithms
    ], (err, changedAlgorithms, addedAlgorithms, removedAlgorithms) =>
      if err?
        logger.log 'error', "iteration status=failed with error=#{err}"
        @_logPause (interval) ->
          setTimeout (-> callback()), interval
      else
        if @pusher
          if changedAlgorithms.length > 0
            @pusher.update changedAlgorithms
          if addedAlgorithms.length > 0
            @pusher.add addedAlgorithms
          if removedAlgorithms.length > 0
            @pusher.delete removedAlgorithms
        if changedAlgorithms.length is 0 and addedAlgorithms.length is 0 and removedAlgorithms.length is 0
          logger.log 'info', 'no changes to apply', 'Poller'
        logger.log 'info', 'iteration status=succeeded', 'Poller'
        @_logPause (interval) ->
          setTimeout (-> callback()), interval

  # ---
  # **_loadHosts**</br>
  # Loads and callbacks all hosts stored in mongoDB
  _loadHosts: (callback) =>
    @db.getHosts (err, hosts) =>
      if err?
        logger.log 'error', 'mongoose error could not load hosts from mongoDB', 'Poller'
        return callback err
      else
        if not hosts.length then logger.log 'info', 'there are no hosts available', 'Poller'
        callback null, hosts

  # ---
  # **_loadAlgorithms**</br>
  # Loads and parses all algorithms for each host. Valid algorithms are called back in an `Array`</br>
  # `params:`
  #   * *hosts* `<Array>` of hosts to poll
  _loadAlgorithms: (hosts, callback) =>
    algorithms = []
    async.each hosts, (host, next) ->
      hostname = host.host or 'undefined'
      if host.url?
        logger.log 'info', "going to load algorithms for #{hostname}", 'Poller'

        settings =
          options:
            uri: host.url
            timeout: 8000
            headers: {}
          retries: nconf.get 'loader:retries'

        loader.get settings, (err, res) ->
          if err?
            logger.log 'error', "loading status=failed for host=#{hostname} error=#{err}", 'Poller'
            next()
          else
            parser.parseRoot res, (err, structure) ->
              if err?
                logger.log 'warn', "could not parse structure and no changes were applied for host=#{hostname} error=#{err}", 'Poller'
                next()
              else
                if (structure?.records?.length > 0)
                  _.each structure.records, (algorithm) ->
                    algorithm.host = hostname
                    algorithms.push algorithm
                else
                  logger.log 'info', "no algorithms available for host=#{hostname}", 'Poller'
                next()
      else
        logger.log 'warn', "#{hostname} does not provide an url. Skipping...", 'Poller'
        next()
    , (err) ->
      if err?
        logger.log 'warn', "loading algorithms status=failed for host=#{hostname}", 'Poller'
        callback null
      else
        callback null, algorithms

  # ---
  # **_compareAndStoreAlgorithms**</br>
  # Iterates over all algorithms and compares them to algorithms stored in mongoDB.
  #   * New algorithms are stored in `addedAlgorithms`
  #   * Updated algorithms are stored in `changedAlgorithms`
  #   * Removed algorithms are stored in `removedAlgorithms`</br>
  #
  # Returns those three arrays</br>
  # `params:`
  #   * *algorithms* `<Array>` of algorithms to process
  _compareAndStoreAlgorithms: (algorithms, callback) =>
    changedAlgorithms = []
    addedAlgorithms = []
    if algorithms?.length > 0
      async.each algorithms, (algorithm, next) =>
        @db.getAlgorithm algorithm.url, (err, dbAlgorithm) =>
          if err?
            logger.log 'warn', 'there was an error while loading one of the algorithms from the mongoDB. Check the mongoose log', 'Poller'
            next()
          else
            if dbAlgorithm?
              dbAlgorithm.compareAndSave algorithm, (err, changes, newAlgorithm) ->
                if err?
                  logger.log 'warn', 'there was an error while comparing algorithms. Check the mongoose log', 'Poller'
                  next()
                else
                  if changes?.length > 0
                    logger.log 'info', "algorithm=#{algorithm.url} for host=#{algorithm.host} has changed", 'Poller'
                    async.each changes, (change, nextChange) ->
                      logger.log 'debug', "type=#{change.type}, attr=#{change.attr}, old=#{change.old}, new=#{change.new}", 'Poller'
                      nextChange()
                    , ->
                      changedAlgorithms.push newAlgorithm
                      next()
                  else
                    logger.log 'debug', "no changes to apply for host=#{algorithm.host}, algorithm=#{algorithm.url}", 'Poller'
                    next()
            else
              alg = new @Algorithm algorithm
              alg.save (err, algorithm) ->
                if err?
                  logger.log 'warn', 'there was an error while storing one of the algorithms. Check the mongoose log', 'Poller'
                else
                  logger.log 'info', "stored new algorithm=#{algorithm.name}", 'Poller'
                  addedAlgorithms.push algorithm
                next()
      , (err) =>
        callback err, algorithms, changedAlgorithms, addedAlgorithms
    else
      logger.log 'info', 'there are no algorithms available', 'Poller'
      callback null, algorithms, changedAlgorithms, addedAlgorithms

  # ---
  # **_removeInvalidAlgorithms**</br>
  # Removes algorithms from mongoDB wich did not pass the previousely steps (either because they are not available anymore or
  # because they have changed and are not valid anymore)</br>
  # `params:`
  #   * *algorithms* `<Array>` of all valid algorithms
  _removeInvalidAlgorithms: (algorithms, callback) =>
    removedAlgorithms = []
    @db.getAlgorithms (err, dbAlgorithms) =>
      if err?
        logger.log 'warn', 'there was an error while loading the algorithms form the mongoDB. Check the mongoose log', 'Poller'
        callback null, removedAlgorithms
      else if dbAlgorithms?
        async.each dbAlgorithms, (dbAlgorithm, next) =>
          index = _.findIndex algorithms, 'url': dbAlgorithm.url
          if index < 0
            logger.log 'info', "removed algorithm host=#{dbAlgorithm.host}, algorithm=#{dbAlgorithm.url}", 'Poller'
            removedAlgorithms.push dbAlgorithm
            @Algorithm.find(url: dbAlgorithm.url).remove().exec()
          next()
        , (err) ->
          if err?
            logger.log 'warn', 'there was an error while deleting one of the algorithms from the mongoDB. Check the mongoose log', 'Poller'
          callback null, removedAlgorithms
      else
        callback null, removedAlgorithms

  # ---
  # **_logPause**</br>
  # Helper function to log pause duration before next iteration starts
  _logPause: (callback) =>
    interval = parseInt nconf.get 'poller:interval'
    switch
      when moment.duration(interval).asYears() >= 1 then logger.log 'info', "going to wait #{moment.duration(interval).years()} years", 'Poller'
      when moment.duration(interval).asMonths() >= 1 then logger.log 'info', "going to wait #{moment.duration(interval).months()} months", 'Poller'
      when moment.duration(interval).asDays() >= 1 then logger.log 'info', "going to wait #{moment.duration(interval).days()} days", 'Poller'
      when moment.duration(interval).asHours() >= 1 then logger.log 'info', "going to wait #{moment.duration(interval).hours()} hours", 'Poller'
      when moment.duration(interval).asMinutes() >= 1 then logger.log 'info', "going to wait #{moment.duration(interval).minutes()} minutes", 'Poller'
      else logger.log 'info', "going to wait #{moment.duration(interval).seconds()} seconds", 'Poller'

    callback interval
