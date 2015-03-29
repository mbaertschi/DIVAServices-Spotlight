logger      = require './logger'
async       = require 'async'
nconf       = require 'nconf'
loader      = require './loader'
parser      = require './parser'
Pusher      = require './pusher'
Mongo       = require './mongo'
_           = require 'lodash'
mongoose    = require 'mongoose'

poller = exports = module.exports = class Poller

  constructor: (io) ->
    logger.log 'info', 'initializing', 'Poller'
    @db = new Mongo
    @Algorithm = mongoose.model('Algorithm')
    if io? then @pusher = new Pusher(io)

  run: =>
    async.forever @_nextIteration, (err) ->
      logger.log 'error', "something went wrong... going to shutdown! #{err}", 'Poller'
      setTimeout (-> process.exit(0)), 2000

  _nextIteration: (callback) =>
    logger.log 'info', 'next iteration', 'Poller'
    async.waterfall [(next) =>
        @_loadHosts next
      , (hosts, next) =>
        @_loadAlgorithms hosts, next
      , (algorithms, next) =>
        @_compareAndStoreAlgorithms algorithms, next
    ], (err, changedAlgorithms, addedAlgorithms, removedAlgorithms) =>
      if err?
        logger.log 'error', "iteration status=failed with error=#{err}"
        seconds = (parseInt nconf.get 'poller:interval') / 1000
        logger.log 'info', "going to wait #{seconds} seconds", 'Poller'
        setTimeout (-> callback()), nconf.get 'poller:interval'
      else
        if nconf.get('pusher:run')
          if (changedAlgorithms?.length > 0)
            @pusher.update changedAlgorithms
          if (addedAlgorithms?.length > 0)
            @pusher.add addedAlgorithms
          if (removedAlgorithms?.length > 0)
            @pusher.delete removedAlgorithms
        logger.log 'info', 'iteration status=succeeded', 'Poller'
        seconds = (parseInt nconf.get 'poller:interval') / 1000
        logger.log 'info', "going to wait #{seconds} seconds", 'Poller'
        setTimeout (-> callback()), nconf.get 'poller:interval'

  _loadHosts: (callback) =>
    @db.getHosts (err, hosts) =>
      if err?
        logger.log 'error', 'mongoose error could not load hosts from mongoDB', 'Poller'
        return callback err
      else
        callback null, hosts

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
          retries: nconf.get 'poller:retries'

        loader.get settings, (err, res) ->
          if err?
            logger.log 'error', "loading status=failed for host=#{hostname}. #{err}", 'Poller'
            next()
          else
            parser.parse res, (err, structure) ->
              if err?
                logger.log 'warn', "could not parse structure and no changes were applied for host #{hostname}. Error = #{err}", 'Poller'
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

  _compareAndStoreAlgorithms: (algorithms, callback) =>
    changedAlgorithms = []
    addedAlgorithms = []
    removedAlgorithms = []
    if algorithms?.length > 0
      async.each algorithms, (algorithm, next) =>
        @db.getAlgorithm algorithm.url, (err, dbAlgorithm) =>
          if err?
            logger.log 'warn', 'there was an error while loading one of the algorithms from the mongoDB. Check the mongoose log', 'Poller'
            next()
          else
            if dbAlgorithm?
              dbAlgorithm.compareAndSave algorithm, (err, changes) ->
                if err?
                  logger.log 'warn', 'there was an error while comparing algorithms. Check the mongoose log', 'Poller'
                  next()
                else
                  if changes?.length > 0
                    logger.log 'info', "algorithm=#{algorithm.url} for host=#{algorithm.host} has changed", 'Poller'
                    async.each changes, (change, nextChange) ->
                      logger.log 'info', "type=#{change.type}, attr=#{change.attr}, old=#{change.old}, new=#{change.new}", 'Poller'
                      nextChange()
                    , ->
                      changedAlgorithms.push algorithm
                      next()
                  else
                    logger.log 'info', "no changes to apply for host=#{algorithm.host}, algorithm=#{algorithm.url}", 'Poller'
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
        return err if err?
        @db.getAlgorithms (err, dbAlgorithms) =>
          if err?
            logger.log 'warn', 'there was an error while loading the algorithms form the mongoDB. Check the mongoose log', 'Poller'
            callback null, changedAlgorithms, addedAlgorithms
          else
            async.each dbAlgorithms, (dbAlgorithm, next) =>
              index = _.findIndex algorithms, 'url': dbAlgorithm.url
              if index < 0
                logger.log 'info', "removed algorithm host=#{dbAlgorithm.host}, algorithm=#{dbAlgorithm.url}", 'Poller'
                removedAlgorithms.push dbAlgorithm
                @Algorithm.find(url: dbAlgorithm.url).remove().exec()
              next()
            , (err) =>
              if err?
                logger.log 'warn', 'there was an error while deleting one of the algorithms from the mongoDB. Check the mongoose log', 'Poller'
              callback null, changedAlgorithms, addedAlgorithms, removedAlgorithms
    else
      logger.log 'info', 'there are no new or updated algorithms to store', 'Poller'
      callback()
