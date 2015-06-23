do ->
  'use strict'

  docs = angular.module 'app.docs'

  stateProvider = ($stateProvider) ->
    $stateProvider.state 'docs',
      parent: 'main'
      abstract: true
      url: '/docs'
      data:
        title: 'Documentation'

    $stateProvider.state 'docs.faq',
      parent: 'main'
      url: '/docs/faq'
      templateUrl: '/modules/docs/faq.view.html'
      data:
        title: 'FAQ'

    $stateProvider.state 'docs.api',
      parent: 'main'
      url: '/docs/api'
      abstract: true
      data:
        title: 'API'

    $stateProvider.state 'docs.api.backend',
      parent: 'main'
      url: '/docs/api/backend'
      templateUrl: '/modules/docs/backend.view.html'
      controller: 'BackendPageController'
      controllerAs: 'vm'
      data:
        title: 'Backend'

    $stateProvider.state 'docs.api.server',
      parent: 'main'
      url: '/docs/api/server'
      templateUrl: '/modules/docs/server.view.html'
      controller: 'ServerPageController'
      controllerAs: 'vm'
      data:
        title: 'Server'

  docs.config stateProvider
