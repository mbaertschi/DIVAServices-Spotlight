angular.module('app.images').controller 'UploadPageController', [
  '$scope'
  'diaStateManager'
  'toastr'

  ($scope, diaStateManager, toastr) ->

    $scope.state = 'upload'

    if diaStateManager.state
      $scope.safeApply ->
        $scope.state = diaStateManager.state
        $scope.currentImage = diaStateManager.image.src

    $scope.$on 'stateChange', ->
      $scope.safeApply ->
        $scope.state = diaStateManager.state
        $scope.currentImage = diaStateManager.image.src

    $scope.goToState = (state) ->
      $scope.safeApply ->
        diaStateManager.switchState state, diaStateManager.image
]
