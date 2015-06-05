###
Controller UploadPageController

* handles state transitions for image uploading and manipulating
###
do ->
  'use strict'

  UploadPageController = ($scope, diaStateManager) ->
    vm = @
    vm.state = 'upload'
    vm.currentImage = null

    # if we come from gallery view, change to state cropping
    if diaStateManager.state
      $scope.safeApply ->
        vm.state = diaStateManager.state
        vm.currentImage = diaStateManager.image.src

    # handle state changes
    $scope.$on 'stateChange', ->
      $scope.safeApply ->
        vm.state = diaStateManager.state
        vm.currentImage = diaStateManager.image.src

    # emit state changes
    $scope.goToState = (state) ->
      $scope.safeApply ->
        diaStateManager.switchState state, diaStateManager.image

    vm

  angular.module('app.images')
    .controller 'UploadPageController', UploadPageController

  UploadPageController.$inject = [
    '$scope'
    'diaStateManager'
  ]
