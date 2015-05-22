angular.module('app.images').factory 'imagesService', [
  '$http'

  ($http) ->

    fetch: ->
      url = '/upload'
      $http.get(url).then (res) ->
        res

    post: (file, name) ->
      if not name
        name = 'undefined.png'
        index = 0
      else
        values = name.split('_')
        index = values[values.length-1].split('.')[0]
      formData = new FormData
      formData.append('filename', name)
      formData.append('file', file)
      formData.append('processType', 'crop')
      formData.append('index', index)
      $http.post('/upload', formData,
        transformRequest: angular.identity
        headers:
          'Content-Type': undefined
          'X-Requested-With': 'XMLHttpRequest').then (res) ->
            res

    delete: (serverName) ->
      $http.delete('/upload', params:
        serverName: serverName).then (res) ->
          res
]
