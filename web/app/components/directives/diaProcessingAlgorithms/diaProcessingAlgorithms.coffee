angular.module('app').directive 'diaProcessingAlgorithms', [
  'diaProcessingQueue'

  (diaProcessingQueue) ->
    restrict: 'EA'
    replace: true
    templateUrl: 'components/directives/diaProcessingAlgorithms/template.html'
    scope: true
    link: (scope, element, attrs) ->
      scope.entries = diaProcessingQueue.queue()

      scope.cancel = (entry) ->
        diaProcessingQueue.abort entry
]
