# ###
# Factory diaSettings
#
# * global service to fetch client settings stored under
#   ./web/conf/client.[dev/prod].json
# ###
do ->
  'use strict'

  diaSettings = ($http) ->

    fetch = (type) ->
      $http.get('/api/settings', params: type: type).then (res) ->
        res.data

    fetch: fetch

  angular.module('app.core')
    .factory 'diaSettings', diaSettings

  diaSettings.$inject = ['$http']
