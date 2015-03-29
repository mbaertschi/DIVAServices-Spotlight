angular.module('app.algorithm').factory 'algorithmService', [
  '$http'

  ($http) ->

    fetch: (host, algorithm) ->
      $http.get('/api/algorithm', params:
        algorithm: algorithm
        host: host).then (res) ->
          res
]
