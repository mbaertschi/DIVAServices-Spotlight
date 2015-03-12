'use strict'

AIRevolution = angular.module 'app', [
  'ui.router'
  'ui.bootstrap'
  'lodash'
  'btford.socket-io'
  'app.dashboard'
  'app.docs'
  'app.algorithms'
  'app.algorithm'
]

AIRevolution.config [
  '$urlRouterProvider'

  # redirect to / if URL is unknown
  ($urlRouterProvider) ->
    $urlRouterProvider.otherwise ($injector) ->
      $state = $injector.get '$state'
      $state.go 'dashboard'
]

AIRevolution.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'main',
      abstract: true
      templateUrl: 'layout/partials/main.html'
]
