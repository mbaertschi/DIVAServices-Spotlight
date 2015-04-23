angular.module('app').directive 'bigBreadcrumbs', [
  '_'

  (_) ->
    restrict: 'E'
    replace: true
    template: '<div><h1 class="page-title txt-color-blueDark"></h1></div>'
    scope:
      items: '='
      icon: '@'
    link: (scope, element) ->
      first = _.first(scope.items)
      icon = scope.icon or 'home'
      element.find('h1').append '<i class="fa-fw fa fa-' + icon + '"></i> ' + first
      _.rest(scope.items).forEach (item) ->
        element.find('h1').append ' <span> > ' + item + '</span>'
        return
      return
]
