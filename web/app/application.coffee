'use strict'

AIRevolution = angular.module 'app', [
  'ui.router'
  'ui.bootstrap'
  'lodash'
  'app.dashboard'
  'app.docs'
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
