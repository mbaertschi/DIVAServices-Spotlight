do ->
  'use strict'

  results = angular.module 'app.images'

  stateProvider = ($stateProvider) ->
    $stateProvider.state 'images',
      parent: 'main'
      abstract: true
      url: '/images'
      data:
        title: 'Images'

    $stateProvider.state 'images.gallery',
      parent: 'main'
      url: '/images/gallery'
      templateUrl: '/modules/images/gallery/gallery.view.html'
      controller: 'GalleryPageController'
      controllerAs: 'vm'
      data:
        title: 'Gallery'
      resolve:
        imagesPrepServiceGallery: imagesPrepServiceGallery

    $stateProvider.state 'images.upload',
      parent: 'main'
      url: '/images/upload'
      templateUrl: '/modules/images/upload/upload.view.html'
      controller: 'UploadPageController'
      controllerAs: 'vm'
      data:
        title: 'Upload'
      resolve:
        imagesPrepServiceUpload: imagesPrepServiceUpload

  imagesPrepServiceGallery = (diaImagesService) ->

    prepareImages = (data) ->
      images = []
      angular.forEach data, (image) ->
        img =
          title: image.clientName.replace('.png', '')
          description: 'Image size: ' + (image.size / 1000000).toFixed(2) + 'MB'
          alt: 'Alt'
          img_thumb: image.thumbUrl + '?' + new Date().getTime()
          img_full: image.url + '?' + new Date().getTime()
          serverName: image.serverName
          clientName: image.clientName
        @push img
      , images
      images

    diaImagesService.fetch().then (res) ->
      images: prepareImages res.data

  imagesPrepServiceUpload = (diaImagesService) ->

    prepareImages = (data) ->
      images = []
      angular.forEach data, (image) ->
        image.mockFile =
          name: image.serverName
          size: image.size
          type: image.type
          index: image.index
          src: image.url
        @push image
      , images
      images

    diaImagesService.fetch().then (res) ->
      images: prepareImages res.data

  results.config stateProvider
