do ->
  'use strict'

  algorithm = angular.module 'app.algorithm'

  stateProvider = ($stateProvider) ->
    $stateProvider.state 'algorithm',
      parent: 'main'
      url: '/algorithm/:id'
      templateUrl: 'modules/algorithm/algorithm.view.html'
      controller: 'AlgorithmPageController'
      controllerAs: 'vm'
      data:
        title: 'Algorithm'

  algorithm.config stateProvider
