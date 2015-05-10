angular.module('app.algorithm').factory 'algorithmService', [
  '$http'

  ($http) ->

    fetch: (host, algorithm) ->
      $http.get('/api/algorithm', params:
        algorithm: algorithm
        host: host).then (res) ->
          res

    checkCaptcha: (params) ->
      data = {}
      data[params.name] = params.value
      name: data.value
      $http.post('/captcha/try/', data).then (res) ->
        res
]
