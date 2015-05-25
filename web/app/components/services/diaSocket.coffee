###
Factory diaSocket

* global service to forward socket.io messages on the specified channels
###
angular.module('app').factory 'diaSocket', [
  'socketFactory'

  (socketFactory) ->
    diaSocket = socketFactory()
    diaSocket.forward 'update algorithms'
    diaSocket.forward 'add algorithms'
    diaSocket.forward 'delete algorithms'
    diaSocket.forward 'error'
    diaSocket
]
