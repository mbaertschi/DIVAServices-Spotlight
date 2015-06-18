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

  diaAlgorithmPolygon = ->

    directive = ->
      restrict: 'AE'
      templateUrl: 'modules/algorithm/diaAlgorithmPolygon/diaAlgorithmPolygon.view.html'
      link: link
      scope:
        selectedImage: '='
        selection: '='
      controller: 'DiaAlgorithmPolygonController'
      controllerAs: 'vm'
      bindToController: true

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    directive()

  angular.module('app.algorithm')
    .directive 'diaAlgorithmPolygon', diaAlgorithmPolygon
