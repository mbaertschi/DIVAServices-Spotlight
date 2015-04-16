'use strict'

DiaDistributed = angular.module 'app', [
  'ui.router'
  'ui.bootstrap'
  'lodash'
  'btford.socket-io'
  'ngAnimate'
  'toastr'
  'app.dashboard'
  'app.docs'
  'app.algorithms'
  'app.algorithm'
]

DiaDistributed.config [
  '$urlRouterProvider'

  # redirect to / if URL is unknown
  ($urlRouterProvider) ->
    $urlRouterProvider.otherwise ($injector) ->
      $state = $injector.get '$state'
      $state.go 'dashboard'
]

DiaDistributed.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'main',
      abstract: true
      templateUrl: 'layout/partials/main.html'
]

DiaDistributed.config [
  'toastrConfig'

  # configuration for toastr notifications
  (toastrConfig) ->
    angular.extend toastrConfig,
      closeButton: true
      progressBar: true
]
