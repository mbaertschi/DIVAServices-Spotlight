angular.module('app.algorithm').directive 'diaAlgorithmInputs', [

  ->
    restrict: 'E'
    templateUrl: 'modules/algorithm/directives/diaAlgorithmInputs/template.html'

    link: (scope, element, attrs) ->

      scope.$watch 'inputForm.$invalid', (value) ->
        scope.setFormValidity value
]
