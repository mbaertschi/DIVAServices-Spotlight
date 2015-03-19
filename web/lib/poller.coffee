logger      = require './logger'
async       = require 'async'
nconf       = require 'nconf'
loader      = require './loader'
parser      = require './parser'
Pusher      = require './pusher'

poller = exports = module.exports = class Poller

  constructor: (io) ->
    logger.log 'info', 'initializing', 'Poller'
    if io? then @pusher = new Pusher(io)

  run: =>
    async.forever @_nextIteration, (err) ->
      logger.log 'error', "something went wrong... going to shutdown! #{err}", 'Poller'
      setTimeout (-> process.exit(0)), 2000

  _nextIteration: (callback) =>
    logger.log 'info', 'next iteration', 'Poller'
    @_loadStructure (err, structure) =>
      if err?
        # we only log error message, but we don't stop server here (callback initializes next iteration)
        logger.log 'error', "iteration status=failed. #{err}", 'Poller'
        seconds = (parseInt nconf.get 'poller:interval') / 1000
        logger.log 'info', "going to wait #{seconds} seconds", 'Poller'
        setTimeout (-> callback()), nconf.get 'poller:interval'
      else
        parser.parse structure, (err, newStructure) =>
          if err?
            logger.log 'warn', "could not parse structure and no changes were applied. Error = #{err}", 'Poller'
            seconds = (parseInt nconf.get 'poller:interval') / 1000
            logger.log 'info', "going to wait #{seconds} seconds", 'Poller'
            setTimeout (-> callback()), nconf.get 'poller:interval'
          else
            logger.log 'info', 'iteration status=succeeded', 'Poller'
            if newStructure? and @pusher? then @pusher.push newStructure
            seconds = (parseInt nconf.get 'poller:interval') / 1000
            logger.log 'info', "going to wait #{seconds} seconds", 'Poller'
            setTimeout (-> callback()), nconf.get 'poller:interval'

  _loadStructure: (callback) ->
    settings =
      options:
        uri: nconf.get 'poller:rootUrl'
        timeout: 8000
        headers: {}
      retries: nconf.get 'poller:retries'

    loader.get settings, (err, res) ->
      return callback err if err?
      callback null, res
