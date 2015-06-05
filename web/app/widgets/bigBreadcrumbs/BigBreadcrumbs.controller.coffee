do ->
  'use strict'

  BigBreadcrumbsController = ->
    vm = @

    @init = (element) ->
      vm.element = element
      first = vm.items[0]
      rest = vm.items.splice(1, vm.items.length)
      icon = vm.icon or 'home'
      vm.element.find('h1').append '<i class="fa-fw fa fa-' + icon + '"></i> ' + first
      angular.forEach rest, (item) ->
        vm.element.find('h1').append ' <span> > ' + item + '</span>'

  angular.module('app.widgets')
    .controller 'BigBreadcrumbsController', BigBreadcrumbsController
