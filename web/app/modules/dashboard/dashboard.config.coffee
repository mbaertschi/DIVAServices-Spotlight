do ->
  'use strict'

  dashboard = angular.module 'app.dashboard'

  stateProvider = ($stateProvider) ->
    $stateProvider.state 'dashboard',
      parent: 'main'
      url: '/'
      templateUrl: '/modules/dashboard/dashboard.view.html'
      controller: 'DashboardPageController'
      controllerAs: 'vm'
      data:
        title: 'Dashboard'

  dashboard.config stateProvider
