###
Directive diaAlgorithmInputs

* watches input form for valid / invalid state and informs parent scope
###
angular.module('app.algorithm').directive 'diaAlgorithmInputs', [

  ->
    restrict: 'E'
    templateUrl: 'modules/algorithm/directives/diaAlgorithmInputs/template.html'

    link: (scope, element, attrs) ->

      # set formValidity in parent scope to valid / invalid
      scope.$watch 'inputForm.$invalid', (value) ->
        scope.setFormValidity value
]
