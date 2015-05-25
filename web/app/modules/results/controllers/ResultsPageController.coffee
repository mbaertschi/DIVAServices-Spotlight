###
Controller ResultsPageController

* loads finished algorithms from diaProcessingQueue
* setups the diaDatatable directive
###
angular.module('app.results').controller 'ResultsPageController', [
  '$scope'
  'diaProcessingQueue'

  ($scope, diaProcessingQueue) ->
    $scope.results = diaProcessingQueue.results()

    $scope.tableOptions =
      data: $scope.results
      iDisplayLength: 15,
      columns: [
        {
          class: 'details-control'
          orderable: false
          data: null
          defaultContent: ''
        }
        { data: 'algorithm.name' }
        { data: 'algorithm.description' }
        { data: 'image.thumbPath' }
        { data: 'submit.start' }
        { data: 'submit.end' }
        { data: 'submit.duration' }
      ]
      order: [[5, 'dsc']]
]
