angular.module('app.results').controller 'ResultsPageController', [
  '$scope'
  'diaProcessingQueue'

  ($scope, diaProcessingQueue) ->
    $scope.results = diaProcessingQueue.results()
]
