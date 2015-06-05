do ->
  'use strict'

  bigBreadcrumbs = ->

    directive = ->
      restrict: 'E'
      template: '<div><h1 class="page-title txt-color-blueDark"></h1></div>'
      replace: true
      scope:
        items: '='
        icon: '@'
      link: link
      controller: 'BigBreadcrumbsController'
      controllerAs: 'vm'
      bindToController: true

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    directive()

  angular.module('app.widgets')
    .directive 'bigBreadcrumbs', bigBreadcrumbs
