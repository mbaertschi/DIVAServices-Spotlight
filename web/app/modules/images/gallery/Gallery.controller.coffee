###
Controller GalleryPageController

* loads and prepars all images for active session
* handles edit / delete event for selected image in gallery
###
do ->
  'use strict'

  GalleryPageController = ($state, diaStateManager, diaImagesService, toastr) ->
    vm = @
    vm.images = []

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

    diaStateManager.reset()

    requestImages = ->
      diaImagesService.fetchGallery().then (res) ->
        vm.images = res.data
      , (err) ->
        toastr.err err.statusText, err.status
      vm.loaded = true

    requestImages()

  angular.module('app.images')
    .controller 'GalleryPageController', GalleryPageController

  GalleryPageController.$inject = ['$state', 'diaStateManager', 'diaImagesService', 'toastr']
