module = angular.module 'app.images', [
  'ui.router'
  'ngAnimate'
  'ngTouch'
  'superbox'
]

module.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'images',
      parent: 'main'
      abstract: true
      url: '/images'
      data:
        title: 'Images'

    $stateProvider.state 'images.gallery',
      parent: 'main'
      url: '/images/gallery'
      templateUrl: '/modules/images/views/gallery/template.html'
      controller: 'GalleryPageController'
      data:
        title: 'Gallery'

    $stateProvider.state 'images.upload',
      parent: 'main'
      url: '/images/upload'
      templateUrl: '/modules/images/views/upload/template.html'
      controller: 'UploadPageController'
      data:
        title: 'Upload'
]
