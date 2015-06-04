###
Directive diaTableInputs

* renders inputs fields for all processed algorithms from diaProcessingQueue results
* if the input has a highlighter field, paperJS will be initialized and the
  path will be drawn on the canvas
###
do ->
  'use strict'

  diaTableInputs = ->

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    restrict: 'A'
    templateUrl: 'modules/results/diaTableInputs/diaTableInputs.view.html'
    scope: inputData: '='
    link: link
    controller: 'DiaTableInputsController'
    controllerAs: 'vm'
    bindToController: true

  angular.module('app.results')
    .directive 'diaTableInputs', diaTableInputs
