angular.module('app.images').controller 'GalleryPageController', [
  '$scope'
  'diaStateManager'
  'imagesService'
  'toastr'

  ($scope, diaStateManager, imagesService, toastr) ->

    $scope.images = []
    $scope.selected = null
    $scope._Index = 0

    requestImages = ->
      imagesService.fetch().then (res) ->
        angular.forEach res.data, (image) ->
          img =
            src: image.url
          $scope.images.push img
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

]
