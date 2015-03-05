'use strict'

Unchained = angular.module 'app', [
  'ui.router'
  'ui.bootstrap'
  'app.navigation'
]

Unchained.config [
  '$urlRouterProvider'

  # redirect to / if URL is unknown
  ($urlRouterProvider) ->
    $urlRouterProvider.otherwise ($injector) ->
      $state = $injector.get '$state'
      $state.go 'dashboard'
]
