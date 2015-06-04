###
Directive diaTableOutputs

* renders output fields for all processed algorithms from diaProcessingQueue results
* if the output has a highlighters field, paperJS will be initialized and the
  path(s) will be drawn on the canvas
###
do ->
  'use strict'

  diaTableOutputs = ->

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    restrict: 'A'
    templateUrl: 'modules/results/diaTableOutputs/diaTableOutputs.view.html'
    scope: outputData: '='
    link: link
    controller: 'DiaTableOutputsController'
    controllerAs: 'vm'
    bindToController: true

  angular.module('app.results')
    .directive 'diaTableOutputs', diaTableOutputs
