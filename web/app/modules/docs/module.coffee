module = angular.module 'app.docs', [
  'ui.router'
]

module.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'docs',
      parent: 'main'
      url: '/docs'
      templateUrl: '/modules/docs/template.html'
      controller: 'DocsPageController'
      data:
        title: 'Documents'
]
