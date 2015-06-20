###
Controller UploadPageController

* handles state transitions for image uploading and manipulating
###
do ->
  'use strict'

  UploadPageController = ($scope, $state, $stateParams, diaStateManager, imagesPrepServiceUpload) ->
    vm = @
    vm.state = 'upload'
    vm.currentImage = null
    vm.images = imagesPrepServiceUpload.images
    vm.algorithmId = $stateParams.algorithmId

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
    vm.goToState = (state) ->
      $scope.safeApply ->
        diaStateManager.switchState state, diaStateManager.image

    vm.goAlgorithms = ->
      if vm.algorithmId
        $state.go 'algorithm', id: vm.algorithmId
      else
        $state.go 'algorithms'

    vm

  angular.module('app.images')
    .controller 'UploadPageController', UploadPageController

  UploadPageController.$inject = [
    '$scope'
    '$state'
    '$stateParams'
    'diaStateManager'
    'imagesPrepServiceUpload'
  ]
