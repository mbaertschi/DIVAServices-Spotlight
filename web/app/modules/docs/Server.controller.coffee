###
Controller ServerPageController

* loads documentation for server from assets folder
###
do ->
  'use strict'

  ServerPageController = ($sce) ->
    vm = @
    vm.currentFile = $sce.trustAsResourceUrl 'documentation/server/server.html'
    vm

  angular.module('app.docs')
    .controller 'ServerPageController', ServerPageController

  ServerPageController.$inject = [
    '$sce'
  ]
