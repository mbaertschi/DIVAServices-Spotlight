###
Controller ServerPageController

* loads documentation for server from assets folder
###
angular.module('app.docs').controller 'ServerPageController', [
  '$scope'
  '$sce'

  ($scope, $sce) ->
    $scope.currentFile = $sce.trustAsResourceUrl 'documentation/server/server.html'
]
