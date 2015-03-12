module = angular.module 'app.algorithm', []

module.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'algorithm',
      parent: 'main'
      url: '/algorithm/:id'
      templateUrl: 'modules/algorithm/template.html'
      controller: 'AlgorithmPageController'
      data:
        title: 'Algorithm'
]
