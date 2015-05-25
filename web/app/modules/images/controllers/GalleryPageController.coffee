angular.module('app.images').controller 'GalleryPageController', [
  '$scope'
  '$state'
  'diaStateManager'
  'diaImagesService'
  'toastr'

  ($scope, $state, diaStateManager, diaImagesService, toastr) ->

    $scope.images = []

    editEntry = (entry) ->
      image =
        src: entry.img_full
        name: entry.serverName
      diaStateManager.switchState 'cropping', image
      $state.go 'images.upload'

    deleteEntry = (entry) ->
      diaImagesService.delete(entry.serverName).then (res) ->
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
      diaImagesService.fetchGallery().then (res) ->
        $scope.images = res.data
      , (err) ->
        toastr.err err.statusText, err.status
      $scope.loaded = true

    requestImages()

]
