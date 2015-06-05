do ->
  'use strict'

  diaImagesService = ($http, toastr) ->

    factory = ->
      fetchImagesAlgorithmGallery: fetchImagesAlgorithmGallery
      fetchImagesUpload: fetchImagesUpload
      fetchImagesGallery: fetchImagesGallery
      put: updateImage
      delete: deleteImage

    fetch = ->
      $http.get('/upload').then (res) ->
        angular.forEach res.data, (image) ->
          # add date to image urls so angularJS triggers change
          image.url = image.url + '?' + new Date().getTime()
          image.thumbUrl = image.thumbUrl + '?' + new Date().getTime()
        res

    fetchImagesAlgorithmGallery = ->
      fetch().then (res) ->
        images: res.data
      , (err) -> toastr.error 'There was an error while fetching images', err.status

    fetchImagesUpload = ->
      fetch().then (res) ->
        angular.forEach res.data, (image) ->
          image.mockFile =
            name: image.serverName
            size: image.size
            type: image.type
            index: image.index
            src: image.url
        images: res.data
      , (err) -> toastr.error 'There was an error while fetching images', err.status

    fetchImagesGallery = ->
      fetch().then (res) ->
        angular.forEach res.data, (image) ->
          img =
            title: image.clientName.replace('.png', '')
            description: 'Image size: ' + (image.size / 1000000).toFixed(2) + 'MB'
            alt: 'Alt'
            img_thumb: image.thumbUrl + '?' + new Date().getTime()
            img_full: image.url + '?' + new Date().getTime()
            serverName: image.serverName
            clientName: image.clientName
          angular.copy img, image
        images: res.data
      , (err) -> toastr.error 'There was an error while fetching images', err.status

    updateImage = (file, name) ->
      if not name
        name = 'undefined.png'
        index = 0
      else
        values = name.split('_')
        index = values[values.length-1].split('.')[0]
      data =
        transformRequest: angular.identity
        headers:
          'Content-Type': undefined
          'X-Requested-With': 'XMLHttpRequest'
      formData = new FormData
      formData.append('filename', name)
      formData.append('file', file)
      formData.append('processType', 'crop')
      formData.append('index', index)
      $http.put('/upload', formData, data).then (res) ->
        res

    deleteImage = (serverName) ->
      $http.delete('/upload', params: serverName: serverName).then (res) ->
        res

    factory()

  angular.module('app.core')
    .factory 'diaImagesService', diaImagesService

  diaImagesService.$inject = [
    '$http'
    'toastr'
  ]
