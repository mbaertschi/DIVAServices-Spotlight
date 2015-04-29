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
      templateUrl: '/documentation/server/method_list.html'
      data:
        title: 'Server Documentation'
]
