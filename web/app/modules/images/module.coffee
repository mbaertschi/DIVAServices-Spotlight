module = angular.module 'app.images', [
  'ui.router'
]

module.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'images',
      parent: 'main'
      url: '/images'
      templateUrl: '/modules/images/template.html'
      controller: 'ImagesPageController'
      data:
        title: 'MyImages'
]
