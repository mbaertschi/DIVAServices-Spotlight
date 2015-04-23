angular.module('app.images').factory 'uploader', [
  '$http'

  ($http) ->

    post: (file, name) ->
      if not name
        name = 'undefined.png'
      formData = new FormData
      formData.append('filename', name)
      formData.append('file', file)
      formData.append('processType', 'crop')
      formData.append('index', 0)
      $http.post('/upload', formData,
        transformRequest: angular.identity
        headers:
          'Content-Type': undefined
          'X-Requested-With': 'XMLHttpRequest').then (res) ->
            res
]
