do ->
  'use strict'

  panel = ->

    link = (scope, element, attrs) ->
      scope.action = attrs.goTo?
      scope.goToIcon ||= 'fa-arrow-left'

    restrict: 'E'
    transclude: true
    replace: true
    templateUrl: 'widgets/panels/panel.view.html'
    scope:
      heading: '@'
      icon: '@'
      goTo: '&'
      goToText: '@'
      goToIcon: '@'
    link: link

  angular.module('app.widgets')
    .directive 'panel', panel
