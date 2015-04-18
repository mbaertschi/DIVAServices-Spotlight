angular.module('app.algorithm').directive 'diaImageFilter', [
  'diaStateManager'

  (diaStateManager) ->
    restrict: 'AC'
    templateUrl: 'modules/algorithm/directives/diaImageFilter/template.html'

    link: (scope, element, attrs) ->
]
