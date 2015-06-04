do ->
  'use strict'

  core = angular.module 'app.core'

  # redirect to / if URL is unknown
  routerProvider = ($urlRouterProvider) ->
    $urlRouterProvider.otherwise ($injector) ->
      $state = $injector.get '$state'
      $state.go 'dashboard'

  # include abstract state main for layout rendering
  stateProvider = ($stateProvider) ->
    $stateProvider.state 'main',
      abstract: true
      templateUrl: 'layout/main.html'

  # configuration for toastr notifications
  toastr = (toastrConfig) ->
    angular.extend toastrConfig,
      closeButton: true
      progressBar: true

  # sometimes we need to use $apply (for third party plugins) in a function
  # which is also applied within the angular framework. In this case we
  # need to check whether the $digest phase is already running or not
  provideSafeDigestCycles = ($provide) ->
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

  core.config routerProvider
  core.config stateProvider
  core.config toastr
  core.config provideSafeDigestCycles
