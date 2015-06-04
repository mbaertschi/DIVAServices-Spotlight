###
Factory diaImagesService

* loads images for Dropzone
* loads images for Gallery
* sends images from cropping / filtering page to server
###
do ->
  'use strict'

  diaImagesService = ($http) ->

    fetchUpload: ->
      $http.get('/upload').then (res) ->
        angular.forEach res.data, (image) ->
          image.url = image.url + '?' + new Date().getTime()
          image.thumbUrl = image.thumbUrl + '?' + new Date().getTime()
          image.mockFile =
            name: image.serverName
            size: image.size
            type: image.type
            index: image.index
            src: image.url
        res

    fetchGallery: ->
      $http.get('/upload').then (res) ->
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
        res

    put: (file, name) ->
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

    delete: (serverName) ->
      $http.delete('/upload', params: serverName: serverName).then (res) ->
        res

  angular.module('app.images')
    .factory 'diaImagesService', diaImagesService

  diaImagesService.$inject = ['$http']
