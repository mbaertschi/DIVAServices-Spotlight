do ->
  'use strict'

  breadcrumbs = ->

    directive = ->
      restrict: 'E'
      replace: true
      template: '<ol class="breadcrumb" />'
      controller: 'BreadcrumbsController'
      controllerAs: 'vm'
      bindToController: true
      link: link

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    directive()

  angular.module('app.widgets')
    .directive 'breadcrumbs', breadcrumbs
