angular.module('app').factory 'mySocket', [
  'socketFactory'

  (socketFactory) ->
    mySocket = socketFactory()
    mySocket.forward 'update algorithms'
    mySocket.forward 'add algorithms'
    mySocket.forward 'delete algorithms'
    mySocket.forward 'error'
    mySocket
]
