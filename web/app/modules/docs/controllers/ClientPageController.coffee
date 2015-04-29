angular.module('app.docs').controller 'ClientPageController', [
  '$scope'
  '$sce'

  ($scope, $sce) ->

    $scope.source = $sce.trustAsResourceUrl("http://localhost:3000/documentation/client/index.html")
]
