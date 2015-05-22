module = angular.module 'app.algorithm', [
  'ui.router'
  'visualCaptcha'
]

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
