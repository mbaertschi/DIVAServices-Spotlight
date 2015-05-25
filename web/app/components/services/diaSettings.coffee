###
Factory diaSettings

* global service to fetch client settings stored under
  ./web/conf/client.[dev/prod].json
###
angular.module('app').factory 'diaSettings', [
  '$http'

  ($http) ->

    fetch: (type) ->
      $http.get('/api/settings', params:
        type: type).then (res) ->
          res.data
]
