do ->
  'use strict'

  diaAlgorithmsService = ($http, diaModelBuilder, toastr) ->

    factory = ->
      fetch: fetch
      fetchAlgorithm: fetchAlgorithm

    fetch = ->
      $http.get('/api/algorithms').then (res) ->
        algorithms: res.data
      , (err) -> toastr.error 'There was an error while fetching algorithms', err.status

    fetchAlgorithm = (id) ->
      $http.get('/api/algorithm', params: id: id).then (res) ->
        diaModelBuilder.prepareAlgorithmInputModel id, res.data
      , (err) -> toastr.error 'There was an error while fetching algorithm', err.status

    factory()

  angular.module('app.core')
    .factory 'diaAlgorithmsService', diaAlgorithmsService

  diaAlgorithmsService.$inject = [
    '$http'
    'diaModelBuilder'
    'toastr'
  ]
