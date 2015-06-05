do ->
  'use strict'

  algorithms = angular.module 'app.algorithms'

  stateProvider = ($stateProvider) ->
    $stateProvider.state 'algorithms',
      parent: 'main'
      url: '/algorithms'
      templateUrl: '/modules/algorithms/algorithms.view.html'
      controller: 'AlgorithmsPageController'
      controllerAs: 'vm'
      data:
        title: 'Algorithms'
      resolve:
        algorithmsPrepService: algorithmsPrepService
        socketPrepService: socketPrepService

  algorithmsPrepService = (diaAlgorithmsService) ->
    diaAlgorithmsService.fetch()

  socketPrepService = (diaSettings) ->
    diaSettings.fetch('socket')

  algorithms.config stateProvider
