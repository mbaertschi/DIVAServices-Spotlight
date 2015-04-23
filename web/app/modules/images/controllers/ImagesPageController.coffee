angular.module('app.images').controller 'ImagesPageController', [
  '$scope'
  'diaStateManager'

  ($scope, diaStateManager) ->

    $scope.state = 'upload'

    $scope.$on 'stateChange', ->
      $scope.safeApply ->
        $scope.state = diaStateManager.state
        $scope.currentImage = diaStateManager.image

    $scope.goToState = (state) ->
      diaStateManager.switchState state
]
