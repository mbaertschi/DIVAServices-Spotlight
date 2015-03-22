module = angular.module 'app.algorithms', [
  'ui.router'
]

module.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'algorithms',
      parent: 'main'
      url: '/algorithms'
      templateUrl: 'modules/algorithms/template.html'
      controller: 'AlgorithmsPageController'
      data:
        title: 'Algorithms'
]
