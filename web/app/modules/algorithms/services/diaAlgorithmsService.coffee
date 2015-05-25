angular.module('app.algorithms').factory 'diaAlgorithmsService', [
  '$http'

  ($http) ->

    fetch: ->
      $http.get('/api/algorithms').then (res) ->
        res
]
