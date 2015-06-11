###
Directive diaAlgorithmPolygon

* manages polygon selection for selectedImage
* uses diaPaperManager for setting up paperJS
* uses diaHighlighterManager for storing information about currently
  selected polygon
* handles mouseDown, mouseUp and mouseDrag events
###
do ->
  'use strict'

  diaAlgorithmCircle = ->

    directive = ->
      restrict: 'AE'
      link: link
      scope:
        selectedImage: '='
        selection: '='
        setHighlighterStatus: '&'
      controller: 'DiaAlgorithmCircleController'
      controllerAs: 'vm'
      bindToController: true

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    directive()

  angular.module('app.algorithm')
    .directive 'diaAlgorithmCircle', diaAlgorithmCircle
