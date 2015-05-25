###
Controller BackendPageController

* loads documentation for backend from assets folder
###
angular.module('app.docs').controller 'BackendPageController', [
  '$scope'
  '$sce'

  ($scope, $sce) ->
    $scope.currentFile = $sce.trustAsResourceUrl 'documentation/backend/server.html'
]
