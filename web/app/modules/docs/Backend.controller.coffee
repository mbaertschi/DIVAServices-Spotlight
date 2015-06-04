###
Controller BackendPageController

* loads documentation for backend from assets folder
###
do ->
  'use strict'

  BackendPageController = ($sce) ->
    vm = @
    vm.currentFile = $sce.trustAsResourceUrl 'documentation/backend/server.html'

  angular.module('app.docs')
    .controller 'BackendPageController', BackendPageController

  BackendPageController.$inject = ['$sce']
