angular.module('app.images').controller 'GalleryPageController', [
  '$scope'
  '$state'
  'diaStateManager'
  'imagesService'
  'toastr'

  ($scope, $state, diaStateManager, imagesService, toastr) ->

    $scope.images = []
    $scope._Index = 0

    diaStateManager.reset()

    requestImages = ->
      imagesService.fetch().then (res) ->
        angular.forEach res.data, (image) ->
          $scope.safeApply ->
            image.url = image.url + '?' + new Date().getTime()
            $scope.images.push image
      , (err) ->
        toastr.err err.statusText, err.status

    requestImages()

    $scope.isActive = (index) ->
      $scope._Index == index

    $scope.showPrev = ->
      $scope._Index = if $scope._Index > 0 then --$scope._Index else $scope.images.length - 1

    $scope.showNext = ->
      $scope._Index = if $scope._Index < $scope.images.length - 1 then ++$scope._Index else 0

    $scope.showImage = (index) ->
      $scope._Index = index

    $scope.edit = ->
      _image = $scope.images[$scope._Index]
      image =
        src: _image.url
        name: _image.serverName
      diaStateManager.switchState 'cropping', image
      $state.go 'images.upload'

]
