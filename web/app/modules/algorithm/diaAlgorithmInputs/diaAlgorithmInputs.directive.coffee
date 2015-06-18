###
Directive diaAlgorithmInputs

* watches input form for valid / invalid state and informs parent scope
###
do ->
  'use strict'

  diaAlgorithmInputs = ->

    directive = ->
      restrict: 'AE'
      templateUrl: 'modules/algorithm/diaAlgorithmInputs/diaAlgorithmInputs.view.html'
      scope:
        algorithm: '='
        model: '='
        inputs: '='
        highlighter: '='
        validHighlighter: '='
        selectedImage: '='
      controller: 'DiaAlgorithmInputsController'
      controllerAs: 'vm'
      bindToController: true

    directive()

  angular.module('app.algorithm')
    .directive 'diaAlgorithmInputs', diaAlgorithmInputs
