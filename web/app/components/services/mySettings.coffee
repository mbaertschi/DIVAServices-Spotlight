angular.module('app').factory 'mySettings', [
  '$http'

  ($http) ->

    fetch: (type) ->
      $http.get('/api/settings', params:
        type: type).then (res) ->
          res.data
]
