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

    deleteEntry = (entry) ->
      imagesService.delete(entry.serverName).then (res) ->
        toastr.info "Deleted image #{entry.clientName}", res.data
        requestImages()
      , (err) ->
        toastr.error "Could not delete image #{entry.clientName}", 'err.status'

    $scope.actions = [
      {
        label: 'Edit'
        action: editEntry
      }
      {
        label: 'Delete'
        action: deleteEntry
      }
    ]

    diaStateManager.reset()

    requestImages = ->
      imagesService.fetch().then (res) ->
        $scope.images = []
        angular.forEach res.data, (image) ->
          img =
            title: image.clientName.replace('.png', '')
            description: 'Image size: ' + (image.size / 1000000) + 'MB'
            alt: 'Alt'
            img_thumb: image.thumbUrl + '?' + new Date().getTime()
            img_full: image.url + '?' + new Date().getTime()
            serverName: image.serverName
            clientName: image.clientName
          @.push img
        , $scope.images
      , (err) ->
        toastr.err err.statusText, err.status
      $scope.loaded = true

    requestImages()

]
