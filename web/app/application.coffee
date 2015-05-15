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
  'app.images'
  'app.results'
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

DiaDistributed.config [
  '$provide'

  # sometimes we need to use $apply (for third party plugins) in a function
  # which is also applied within the angular framework. In this case we
  # need to check whether the $digest phase is already running or not
  ($provide) ->
    $provide.decorator '$rootScope', [
      '$delegate'
      ($delegate) ->
        $delegate.safeApply = (fn) ->
          phase = $delegate.$$phase
          if phase is '$apply' or phase is '$digest'
            if fn and typeof fn is 'function'
              fn()
          else
            $delegate.$apply fn
          return
        $delegate
    ]
]
