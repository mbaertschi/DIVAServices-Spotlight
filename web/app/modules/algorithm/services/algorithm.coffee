angular.module('app.algorithm').factory 'algorithmService', [
  '$http'

  ($http) ->

    fetch: (id) ->
      $http.get('/api/algorithm', params:
        id: id).then (res) ->
          res

    checkCaptcha: (params) ->
      data = {}
      data[params.name] = params.value
      name: data.value
      $http.post('/captcha/try/', data).then (res) ->
        res
]
