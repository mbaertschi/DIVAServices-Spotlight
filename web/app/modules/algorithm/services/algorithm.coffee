angular.module('app.algorithm').factory 'algorithmService', [
  '$http'

  ($http) ->

    fetch: (url) ->
      $http.post('/api/algorithm', url: url).then (res) ->
        res
]
