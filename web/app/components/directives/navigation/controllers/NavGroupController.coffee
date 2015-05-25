angular.module('app').controller 'NavGroupController', [
  '$scope'

  ($scope) ->
    $scope.active = false
    $scope.hasIcon = angular.isDefined($scope.icon)
    $scope.hasIconCaption = angular.isDefined($scope.iconCaption)

    @setActive = (active) ->
      $scope.active = active

    return
]
