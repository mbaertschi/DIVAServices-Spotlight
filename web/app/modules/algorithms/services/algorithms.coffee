angular.module('app.algorithms').factory 'algorithmsService', [
  '$http'

  ($http) ->

    fetch: ->
      $http.get('/api/algorithms').then (res) ->
        res
]
