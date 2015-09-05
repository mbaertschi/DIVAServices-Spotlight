do ->
  'use strict'

  home = angular.module 'app.home'

  stateProvider = ($stateProvider) ->
    $stateProvider.state 'home',
      parent: 'main'
      url: '/'
      templateUrl: '/modules/home/home.view.html'
      controller: 'HomePageController'
      controllerAs: 'vm'
      data:
        title: 'Home'

  home.config stateProvider
