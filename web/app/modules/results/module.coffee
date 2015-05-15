module = angular.module 'app.results', [
  'ui.router'
]

module.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'results',
      parent: 'main'
      url: '/results'
      templateUrl: 'modules/results/template.html'
      controller: 'ResultsPageController'
      data:
        title: 'Results'
]
