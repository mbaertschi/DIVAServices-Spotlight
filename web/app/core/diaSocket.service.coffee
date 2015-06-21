# ###
# Factory diaSocket
#
# * global service to forward socket.io messages on the specified channels
# ###
do ->
  'use strict'

  diaSocket = (socketFactory) ->
    diaSocket = socketFactory()
    diaSocket.forward 'update algorithms'
    diaSocket.forward 'add algorithms'
    diaSocket.forward 'delete algorithms'
    diaSocket.forward 'error'
    diaSocket.forward 'session_expired'
    diaSocket

  angular.module('app.core')
    .factory 'diaSocket', diaSocket

  diaSocket.$inject = [
    'socketFactory'
  ]
