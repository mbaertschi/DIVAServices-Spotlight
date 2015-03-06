module = angular.module 'app.dashboard', []

module.config [
  '$stateProvider'

  ($stateProvider) ->
    $stateProvider.state 'dashboard',
      parent: 'main'
      url: '/'
      templateUrl: '/modules/dashboard/template.html'
      controller: 'DashboardPageController'
      data:
        title: 'Dashboard'
]
