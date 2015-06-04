###
Directive diaAlgorithmInputs

* watches input form for valid / invalid state and informs parent scope
###
do ->
  'use strict'

  diaAlgorithmInputs = ->

    link = (scope, element, attrs) ->
      # set formValidity in parent scope to valid / invalid
      scope.$watch 'inputForm.$invalid', (value) ->
        scope.setFormValidity status: value

    restrict: 'AE'
    templateUrl: 'modules/algorithm/diaAlgorithmInputs/diaAlgorithmInputs.view.html'
    scope:
      model: '='
      inputs: '='
      setFormValidity: '&'
    link: link

  angular.module('app.algorithm')
    .directive 'diaAlgorithmInputs', diaAlgorithmInputs
