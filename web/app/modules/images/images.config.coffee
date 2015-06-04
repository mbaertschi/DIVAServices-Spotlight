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

    $stateProvider.state 'images.upload',
      parent: 'main'
      url: '/images/upload'
      templateUrl: '/modules/images/upload/upload.view.html'
      controller: 'UploadPageController'
      controllerAs: 'vm'
      data:
        title: 'Upload'

  results.config stateProvider
