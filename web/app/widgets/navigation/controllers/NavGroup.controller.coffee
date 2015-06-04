do ->
  'use strict'

  NavGroupController = ($scope) ->
    $scope.active = false
    $scope.hasIcon = angular.isDefined($scope.icon)
    $scope.hasIconCaption = angular.isDefined($scope.iconCaption)

    @setActive = (active) ->
      $scope.active = active

  angular.module('app.widgets')
    .controller 'NavGroupController', NavGroupController

  NavGroupController.$injector = ['$scope']
