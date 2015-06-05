###
Directive diaProcessingAlgorithms

* displays processing queue of algorithms in page header
* handles abort for submitted algorithms
###
do ->
  'use strict'

  diaProcessingAlgorithms = (diaProcessingQueue) ->

    directive = ->
      restrict: 'EA'
      templateUrl: 'widgets/processingQueue/processingQueue.view.html'
      link: link

    link = (scope, element, attrs) ->
      scope.entries = diaProcessingQueue.getQueue()
      scope.cancel = (entry) ->
        diaProcessingQueue.abort entry

    directive()

  angular.module('app.widgets')
    .directive 'diaProcessingAlgorithms', diaProcessingAlgorithms

  diaProcessingAlgorithms.$inject = [
    'diaProcessingQueue'
  ]
