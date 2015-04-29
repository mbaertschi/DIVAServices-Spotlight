angular.module('app.docs').controller 'ServerPageController', [
  '$scope'
  '$sce'

  ($scope, $sce) ->

    $scope.source = $sce.trustAsResourceUrl("http://localhost:3000/documentation/server/index.html")
]
