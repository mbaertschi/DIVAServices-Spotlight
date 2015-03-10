angular.module('app.algorithms').factory 'algorithmService', [
  '$http'

  ($http) ->
    
    fetch: ->
      $http.get('/algorithms').then (res) ->
        res
]
