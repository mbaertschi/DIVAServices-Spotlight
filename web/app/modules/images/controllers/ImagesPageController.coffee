angular.module('app.images').controller 'ImagesPageController', [
  '$scope'
  'diaStateManager'
  'imagesService'
  'toastr'

  ($scope, diaStateManager, imagesService, toastr) ->

    $scope.state = 'gallery'
    $scope.images = []
    $scope.selected = null

    requestImages = ->
      imagesService.fetch().then (res) ->
        if not res.data.length
          $scope.state = 'upload'
        else
          angular.forEach res.data, (image) ->
            img =
              id: image.index
              src: image.url
            $scope.images.push img
      , (err) ->
        toastr.err err.statusText, err.status

    requestImages()

    $scope.$on 'stateChange', ->
      $scope.safeApply ->
        $scope.state = diaStateManager.state
        $scope.currentImage = diaStateManager.image

    $scope.goToState = (state) ->
      diaStateManager.switchState state
]
