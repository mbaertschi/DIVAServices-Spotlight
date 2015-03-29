logger      = require '../lib/logger'

module.exports = (socket) ->

  socket.on 'push', (algorithms) ->
    logger.log 'info', 'pushing algorithms', 'Socket'
    socket.emit 'update algorithms', algorithms
