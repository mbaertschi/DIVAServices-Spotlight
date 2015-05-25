angular.module('app').factory 'diaSettings', [
  '$http'

  ($http) ->

    fetch: (type) ->
      $http.get('/api/settings', params:
        type: type).then (res) ->
          res.data
]
