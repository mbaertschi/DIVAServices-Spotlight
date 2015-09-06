do ->
  'use strict'

  HomePageController = ($state) ->
    vm = @

    vm.go = (state) ->
      $state.go state

    vm

  angular.module('app.home')
    .controller 'HomePageController', HomePageController

  HomePageController.$inject = [
    '$state'
  ]
