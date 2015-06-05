# ###
# Factory diaSettings
#
# * global service to fetch client settings stored under
#   ./web/conf/client.[dev/prod].json
# ###
do ->
  'use strict'

  diaSettings = ($http) ->

    factory = ->
      fetch: fetch

    fetch = (type) ->
      $http.get('/api/settings', params: type: type).then (res) ->
        settings: res.data

    factory()

  angular.module('app.core')
    .factory 'diaSettings', diaSettings

  diaSettings.$inject = [
    '$http'
  ]
