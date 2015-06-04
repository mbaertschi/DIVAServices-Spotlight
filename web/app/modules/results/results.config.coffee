do ->
  'use strict'

  results = angular.module 'app.results'

  stateProvider = ($stateProvider) ->
    $stateProvider.state 'results',
      parent: 'main'
      url: '/results'
      templateUrl: 'modules/results/results.view.html'
      controller: 'ResultsPageController'
      controllerAs: 'vm'
      data:
        title: 'Results'

  results.config stateProvider
