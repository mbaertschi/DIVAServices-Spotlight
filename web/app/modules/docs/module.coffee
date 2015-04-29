module = angular.module 'app.docs', [
  'ui.router'
]

module.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'docs',
      parent: 'main'
      abstract: true
      url: '/docs'
      data:
        title: 'Documents'

    $stateProvider.state 'docs.server',
      parent: 'main'
      url: '/docs/server'
      templateUrl: 'modules/docs/views/server.html'
      controller: 'ServerPageController'
      data:
        title: 'Server Documentation'

    $stateProvider.state 'docs.client',
      parent: 'main'
      url: '/docs/client'
      templateUrl: 'modules/docs/views/client.html'
      controller: 'ClientPageController'
      data:
        title: 'Client Documentation'

    $stateProvider.state 'docs.api',
      parent: 'main'
      url: '/docs/api'
      templateUrl: 'modules/docs/views/api.html'
      data:
        title: 'API Documentation'
]
