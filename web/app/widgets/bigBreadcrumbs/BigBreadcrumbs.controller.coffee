do ->
  'use strict'

  BigBreadcrumbsController = ($scope, _) ->
    vm = @
    first = _.first(vm.items)
    icon = vm.icon or 'home'

    @init = (element) ->
      vm.element = element
      apply()

    apply = ->
      vm.element.find('h1').append '<i class="fa-fw fa fa-' + icon + '"></i> ' + first

      _.rest(vm.items).forEach (item) ->
        vm.element.find('h1').append ' <span> > ' + item + '</span>'

  angular.module('app.widgets')
    .controller 'BigBreadcrumbsController', BigBreadcrumbsController

  BigBreadcrumbsController.$inject = ['$scope', '_']
