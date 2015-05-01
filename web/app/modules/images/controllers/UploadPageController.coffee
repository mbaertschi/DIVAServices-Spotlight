angular.module('app.images').controller 'UploadPageController', [
  '$scope'
  'diaStateManager'
  'imagesService'
  'toastr'

  ($scope, diaStateManager, imagesService, toastr) ->

    $scope.state = 'upload'

    if diaStateManager.state
      $scope.state = diaStateManager.state
      $scope.currentImage = diaStateManager.image

    $scope.$on 'stateChange', ->
      $scope.safeApply ->
        $scope.state = diaStateManager.state
        $scope.currentImage = diaStateManager.image

    $scope.goToState = (state) ->
      diaStateManager.switchState state
]
