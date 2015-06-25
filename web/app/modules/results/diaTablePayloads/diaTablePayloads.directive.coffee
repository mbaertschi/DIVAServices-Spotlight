do ->
  'use strict'

  diaTablePayloads = ->

    directive = ->
      restrict: 'A'
      templateUrl: 'modules/results/diaTablePayloads/diaTablePayloads.view.html'
      scope: payloadData: '='
      link: link

    link = (scope, element, attrs) ->
      scope.displayPayloads = true

    directive()

  angular.module('app.results')
    .directive 'diaTablePayloads', diaTablePayloads
