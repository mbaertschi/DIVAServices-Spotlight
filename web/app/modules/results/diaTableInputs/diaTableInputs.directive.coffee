###
Directive diaTableInputs

* renders inputs fields for all processed algorithms from diaProcessingQueue results
* if the input has a highlighter field, paperJS will be initialized and the
  path will be drawn on the canvas
###
do ->
  'use strict'

  diaTableInputs = ->

    directive = ->
      restrict: 'A'
      templateUrl: 'modules/results/diaTableInputs/diaTableInputs.view.html'
      scope: inputData: '='
      link: link
      controller: 'DiaTableInputsController'
      controllerAs: 'vm'
      bindToController: true

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    directive()

  angular.module('app.results')
    .directive 'diaTableInputs', diaTableInputs
