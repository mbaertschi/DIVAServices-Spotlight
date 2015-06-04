###
Controller UploadPageController

* handles state transitions for image uploading and manipulating
###
do ->
  'use strict'

  UploadPageController = ($scope, diaStateManager, toastr) ->
    vm = @
    vm.state = 'upload'
    vm.currentImage = null

    if diaStateManager.state
      $scope.safeApply ->
        vm.state = diaStateManager.state
        vm.currentImage = diaStateManager.image.src

    $scope.$on 'stateChange', ->
      $scope.safeApply ->
        vm.state = diaStateManager.state
        vm.currentImage = diaStateManager.image.src

    $scope.goToState = (state) ->
      $scope.safeApply ->
        diaStateManager.switchState state, diaStateManager.image

  angular.module('app.images')
    .controller 'UploadPageController', UploadPageController

  UploadPageController.$inject = ['$scope', 'diaStateManager', 'toastr']
