angular.module('app.docs').controller 'BackendPageController', [
  '$scope'
  '$sce'

  ($scope, $sce) ->
    $scope.currentFile = $sce.trustAsResourceUrl 'documentation/backend/server.html'
]
