do ->
  'use strict'

  BreadcrumbsController = ($rootScope, $state) ->
    vm = @

    @init = (element) ->
      vm.element = element
      processState $state.current

    setBreadcrumbs = (breadcrumbs) ->
      html = '<li>Home</li>'

      angular.forEach breadcrumbs, (crumb) ->
        html += '<li>' + crumb + '</li>'

      vm.element.html html

    fetchBreadcrumbs = (stateName, breadcrumbs) ->
      state = $state.get(stateName)
      if state and state.data and state.data.title and breadcrumbs.indexOf(state.data.title) is -1
        breadcrumbs.unshift state.data.title

      parentName = stateName.replace /.?\w+$/, ''

      if parentName
        fetchBreadcrumbs parentName, breadcrumbs
      else
        breadcrumbs

    processState = (state) ->
      breadcrumbs = null
      if state.data and state.data.breadcrumbs
        breadcrumbs = state.data.breadcrumbs
      else
        breadcrumbs = fetchBreadcrumbs(state.name, [])
      setBreadcrumbs breadcrumbs

    $rootScope.$on '$stateChangeStart', (event, state) ->
      processState state

  angular.module('app.widgets')
    .controller 'BreadcrumbsController', BreadcrumbsController

  BreadcrumbsController.$injector = [
    '$rootScope'
    '$state'
  ]
