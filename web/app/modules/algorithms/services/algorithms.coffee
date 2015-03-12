angular.module('app.algorithms').factory 'algorithmService', [
  '$http'

  ($http) ->

    fetch: ->
      $http.get('/api/algorithms').then (res) ->
        res
]
