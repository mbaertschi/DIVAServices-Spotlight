angular.module('app.results').directive 'diaTableInputs', [

  ->
    restrict: 'A'
    scope:
      inputData: '='
    templateUrl: 'modules/results/directives/diaTableInputs/template.html'

    link: (scope, element, attrs) ->
      
]
