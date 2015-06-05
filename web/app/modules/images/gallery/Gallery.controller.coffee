###
Controller GalleryPageController

* loads and prepars all images for active session
* handles edit / delete event for selected image in gallery
###
do ->
  'use strict'

  GalleryPageController = ($state, diaStateManager, diaImagesService, imagesPrepService, toastr) ->
    vm = @
    vm.images = imagesPrepService.images

    diaStateManager.reset()

    editEntry = (entry) ->
      image =
        src: entry.img_full
        name: entry.serverName
      diaStateManager.switchState 'cropping', image
      $state.go 'images.upload'

    deleteEntry = (entry) ->
      diaImagesService.delete(entry.serverName).then (res) ->
        toastr.info "Deleted image #{entry.clientName}", res.data
        diaImagesService.fetchImagesGallery().then (res) ->
          vm.images = res.images
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
    'imagesPrepService'
    'toastr'
  ]
