do ->
  'use strict'

  navigation = ->

    link = (scope, element, attrs) ->
      $(element[0]).jarvismenu
        accordion: true
        speed: 350
        closedSign: '<em class="fa fa-plus-square-o"></em>'
        openedSign: '<em class="fa fa-minus-square-o"></em>'
      scope.getElement = -> element

    restrict: 'AE'
    transclude: true
    replace: true
    template: '<nav><ul ng-transclude></ul></nav>'
    link: link

  angular.module('app.widgets')
    .directive 'navigation', navigation
