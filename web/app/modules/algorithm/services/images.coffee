angular.module('app.algorithm').factory 'imagesService', [
  '$http'

  ($http) ->

    fetch: ->
      $http.get('/upload').then (res) ->
        res
]
