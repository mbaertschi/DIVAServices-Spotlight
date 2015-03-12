logger      = require './logger'
nconf       = require 'nconf'

pusher = exports = module.exports = class Pusher

  constructor: (io) ->
    logger.log 'info', 'initializing', 'Pusher'
    @io = io

  push: (newStructure) =>
    logger.log 'info', "pushing new structure, #{newStructure}", 'Pusher'
    @io.emit 'update structure', newStructure
