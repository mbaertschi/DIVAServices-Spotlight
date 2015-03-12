logger      = require '../lib/logger'

module.exports = (socket) ->

  socket.on 'push', (newStructure) ->
    logger.log 'info', 'pushing structure', 'Socket'
    socket.emit 'update structure', newStructure
