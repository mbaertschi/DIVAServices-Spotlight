angular.module('app.results').directive 'diaTableOutputs', [

  ->
    restrict: 'A'
    scope:
      outputData: '='
    templateUrl: 'modules/results/directives/diaTableOutputs/template.html'

    link: (scope, elemnt, attrs) ->

]
