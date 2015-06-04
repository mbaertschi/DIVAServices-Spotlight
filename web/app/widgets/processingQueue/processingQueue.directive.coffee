###
Directive diaProcessingAlgorithms

* displays processing queue of algorithms in page header
* handles abort for submitted algorithms
###
do ->
  'use strict'

  diaProcessingAlgorithms = (diaProcessingQueue) ->

    link = (scope, element, attrs) ->
      scope.entries = diaProcessingQueue.queue()

      scope.cancel = (entry) ->
        diaProcessingQueue.abort entry

    restrict: 'EA'
    templateUrl: 'widgets/processingQueue/processingQueue.view.html'
    link: link

  angular.module('app.widgets')
    .directive 'diaProcessingAlgorithms', diaProcessingAlgorithms

  diaProcessingAlgorithms.$inject = ['diaProcessingQueue']
