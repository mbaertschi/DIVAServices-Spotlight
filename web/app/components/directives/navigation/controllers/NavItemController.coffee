angular.module('app').controller 'NavItemController', [
  '$rootScope'
  '$scope'
  '$location'

  ($rootScope, $scope, $location) ->
    $scope.isChild = false
    $scope.active = false

    $scope.isActive = (viewLocation) ->
      $scope.active = viewLocation is '/#'+$location.path()
      $scope.active

    $scope.hasIcon = angular.isDefined($scope.icon)
    $scope.hasIconCaption = angular.isDefined($scope.iconCaption)

    $scope.getItemUrl = (view) ->
      return $scope.href if angular.isDefined($scope.href)
      return '' unless angular.isDefined(view)
      view

    $scope.getItemTarget = ->
      if angular.isDefined($scope.target) then $scope.target else '_self'
]
