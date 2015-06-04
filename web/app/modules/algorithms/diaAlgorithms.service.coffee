###
Factory diaAlgorithmsService

* loads information for all available algorithms
###
do ->
  'use strict'

  diaAlgorithmsService = ($http) ->

    fetch: ->
      $http.get('/api/algorithms').then (res) ->
        res

  diaAlgorithmsService.$inject = ['$http']
  angular.module('app.algorithms')
    .factory 'diaAlgorithmsService', diaAlgorithmsService
