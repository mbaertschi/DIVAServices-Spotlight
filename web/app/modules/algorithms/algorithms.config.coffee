do ->
  'use strict'

  algorithms = angular.module 'app.algorithms'

  stateProvider = ($stateProvider) ->
    $stateProvider.state 'algorithms',
      parent: 'main'
      url: '/algorithms'
      templateUrl: 'modules/algorithms/algorithms.view.html'
      controller: 'AlgorithmsPageController'
      controlelrAs: 'vm'
      data:
        title: 'Algorithms'

  algorithms.config stateProvider
