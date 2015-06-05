do ->
  'use strict'

  NavItemController = ($scope, $location) ->
    $scope.active = false
    $scope.hasIcon = angular.isDefined($scope.icon)
    $scope.hasIconCaption = angular.isDefined($scope.iconCaption)
    $scope.isChild = false

    $scope.isActive = (viewLocation) ->
      $scope.active = viewLocation is '/#'+$location.path()
      $scope.active

    $scope.getItemUrl = (view) ->
      return $scope.href if angular.isDefined($scope.href)
      return '' unless angular.isDefined(view)
      view

    $scope.getItemTarget = ->
      if angular.isDefined($scope.target) then $scope.target else '_self'

  angular.module('app.widgets')
    .controller 'NavItemController', NavItemController

  NavItemController.$injector = [
    '$scope'
    '$location'
  ]
