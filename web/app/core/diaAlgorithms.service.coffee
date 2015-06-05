do ->
  'use strict'

  diaAlgorithmsService = ($http, toastr) ->

    factory = ->
      fetch: fetch
      fetchAlgorithm: fetchAlgorithm

    fetch = ->
      $http.get('/api/algorithms').then (res) ->
        algorithms: res.data
      , (err) -> toastr.error 'There was an error while fetching algorithms', err.status

    fetchAlgorithm = (id) ->
      $http.get('/api/algorithm', params: id: id).then (res) ->
        data =
          highlighter: null
          inputs: []
          model: {}
          algorithm: res.data

        data.algorithm.id = id

        # prepare input information
        angular.forEach res.data.input, (entry) ->
          key = Object.keys(entry)[0]
          if key is 'highlighter'
            # setup highlighter if there is one
            data.highlighter = entry.highlighter
          else
            # setup inputs
            data.inputs.push entry
            if key is 'select'
              data.model[entry[key].name] = entry[key].options.values[entry[key].options.default]
            else
              data.model[entry[key].name] = entry[key].options.default or null
        data: data
      , (err) -> toastr.error 'There was an error while fetching algorithm', err.status

    factory()

  angular.module('app.core')
    .factory 'diaAlgorithmsService', diaAlgorithmsService

  diaAlgorithmsService.$inject = [
    '$http'
    'toastr'
  ]
