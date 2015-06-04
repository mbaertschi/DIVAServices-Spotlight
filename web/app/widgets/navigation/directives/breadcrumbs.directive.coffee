do ->
  'use strict'

  breadcrumbs = ->

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    restrict: 'E'
    replace: true
    template: '<ol class="breadcrumb" />'
    controller: 'BreadcrumbsController'
    controllerAs: 'vm'
    bindToController: true
    link: link

  angular.module('app.widgets')
    .directive 'breadcrumbs', breadcrumbs
