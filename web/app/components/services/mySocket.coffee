angular.module('app').factory 'mySocket', [
  'socketFactory'

  (socketFactory) ->
    mySocket = socketFactory()
    mySocket.forward 'update structure'
    mySocket.forward 'error'
    mySocket
]
