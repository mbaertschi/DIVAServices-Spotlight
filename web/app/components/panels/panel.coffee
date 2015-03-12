angular.module('app').directive 'panel', ->
  restrict: 'E'
  transclude: true
  replace: true
  templateUrl: 'components/panels/template.html'
  scope:
    heading: '@'
    icon: '@'
    goTo: '&'

  link: (scope, element, attrs)->

    body  = element.find('.panel-body')
    table = body.children('table, .table-responsive, .list-group')
    body.replaceWith table if table.length > 0

    scope.openAlgorithm = attrs.goTo?
