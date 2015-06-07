###
Controller GalleryPageController

* loads and prepars all images for active session
* handles edit / delete event for selected image in gallery
###
do ->
  'use strict'

  GalleryPageController = ($state, diaStateManager, diaImagesService, imagesPrepServiceGallery, toastr) ->
    vm = @
    vm.images = imagesPrepServiceGallery.images

    diaStateManager.reset()

    editEntry = (entry) ->
      image =
        src: entry.img_full
        name: entry.serverName
      diaStateManager.switchState 'cropping', image
      $state.go 'images.upload'

    deleteEntry = (entry) ->
      diaImagesService.delete(entry.serverName).then (res) ->
        angular.forEach vm.images, (image, index) ->
          if image.id is entry.id then vm.images.splice index, 1
        toastr.info "Deleted image #{entry.clientName}", res.data
      , (err) -> toastr.error 'Could not delete image', err.status

    vm.actions = [
      {
        label: 'Edit'
        action: editEntry
      }
      {
        label: 'Delete'
        action: deleteEntry
      }
    ]

    vm

  angular.module('app.images')
    .controller 'GalleryPageController', GalleryPageController

  GalleryPageController.$inject = [
    '$state'
    'diaStateManager'
    'diaImagesService'
    'imagesPrepServiceGallery'
    'toastr'
  ]
