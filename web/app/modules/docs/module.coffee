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

    $stateProvider.state 'docs.howto',
      parent: 'main'
      url: '/docs/howto'
      templateUrl: 'modules/docs/views/howto.html'
      data:
        title: 'HowTo'

    $stateProvider.state 'docs.faq',
      parent: 'main'
      url: '/docs/faq'
      templateUrl: 'modules/docs/views/faq.html'
      data:
        title: 'FAQ'

    $stateProvider.state 'docs.api',
      parent: 'main'
      url: '/docs/api'
      abstract: true
      data:
        title: 'API Documentation'

    $stateProvider.state 'docs.api.backend',
      parent: 'main'
      url: '/docs/api/backend'
      templateUrl: 'modules/docs/views/backend.html'
      controller: 'BackendPageController'
      data:
        title: 'Backend'

    $stateProvider.state 'docs.api.server',
      parent: 'main'
      url: '/docs/api/server'
      templateUrl: 'modules/docs/views/server.html'
      controller: 'ServerPageController'
      data:
        title: 'Server'
]
