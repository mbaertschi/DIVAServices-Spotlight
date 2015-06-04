###
Directive diaAlgorithmRectangle

* manages rectangle selection for selectedImage
* uses diaPaperManager for setting up paperJS
* uses diaHighlighterManager for storing information about currently
  selected rectangle
* handles mouseDown, mouseUp and mouseDrag events
###
do ->
  'use strict'

  diaAlgorithmRectangle = ->

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    restrict: 'AE'
    link: link
    scope:
      selectedImage: '='
      setHighlighterStatus: '&'
    controller: 'DiaAlgorithmRectangleController'
    controllerAs: 'vm'
    bindToController: true

  angular.module('app.algorithm')
    .directive 'diaAlgorithmRectangle', diaAlgorithmRectangle
