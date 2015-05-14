angular.module('app.images').controller 'GalleryPageController', [
  '$scope'
  '$state'
  'diaStateManager'
  'imagesService'
  'toastr'

  ($scope, $state, diaStateManager, imagesService, toastr) ->

    $scope.images = []

    editEntry = (entry) ->
      image =
        src: entry.img_full
        name: entry.serverName
      diaStateManager.switchState 'cropping', image
      $state.go 'images.upload'

    $scope.actions = [
      {
        label: 'Edit'
        action: editEntry
      }
    ]

    diaStateManager.reset()

    requestImages = ->
      imagesService.fetch().then (res) ->
        angular.forEach res.data, (image) ->
          img =
            title: image.clientName.replace('.png', '')
            description: 'Image size: ' + (image.size / 1000000) + 'MB'
            alt: 'Alt'
            img_thumb: image.thumbUrl + '?' + new Date().getTime()
            img_full: image.url + '?' + new Date().getTime()
            serverName: image.serverName
          @.push img
        , $scope.images
      , (err) ->
        toastr.err err.statusText, err.status
      $scope.loaded = true

    requestImages()

]
