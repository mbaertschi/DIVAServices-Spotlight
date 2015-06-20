do ->
  'use strict'

  diaAlgorithmHighlighter = ->

    directive = ->
      restrict: 'AE'
      templateUrl: 'modules/algorithm/diaAlgorithmHighlighter/diaAlgorithmHighlighter.view.html'
      link: link
      scope:
        highlighter: '='
        selectedImage: '='
        selection: '='
      controller: 'DiaAlgorithmHighlighterController'
      controllerAs: 'vm'
      bindToController: true

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    directive()

  angular.module('app.algorithm')
    .directive 'diaAlgorithmHighlighter', diaAlgorithmHighlighter
