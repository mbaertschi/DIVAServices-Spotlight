logger      = require './logger'

pusher = exports = module.exports = class Pusher

  constructor: (io) ->
    logger.log 'info', 'initializing', 'Pusher'
    @io = io

  update: (algorithms) =>
    logger.log 'info', 'pushing algorithm updates', 'Pusher'
    @io.emit 'update algorithms', algorithms

  add: (algorithms) =>
    logger.log 'info', 'pushing new algorithms', 'Pusher'
    @io.emit 'add algorithms', algorithms

  delete: (algorithms) =>
    logger.log 'info', 'pushing algorithms to remove', 'Pusher'
    @io.emit 'delete algorithms', algorithms
