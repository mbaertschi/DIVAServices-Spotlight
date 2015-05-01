angular.module('app.images').controller 'GalleryPageController', [
  '$scope'
  '$state'
  'diaStateManager'
  'imagesService'
  'toastr'

  ($scope, $state, diaStateManager, imagesService, toastr) ->

    $scope.images = []
    $scope.selected = null
    $scope._Index = 0

    requestImages = ->
      imagesService.fetch().then (res) ->
        angular.forEach res.data, (image) ->
          @.push image
        , $scope.images
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
      image = $scope.images[$scope._Index]
      diaStateManager.switchState 'cropping', image.url, image.url, image.url
      $state.go 'images.upload'

]
