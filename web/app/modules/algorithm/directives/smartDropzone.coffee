angular.module('app.algorithm').directive 'smartDropzone', [
  '$http'
  'mySettings'
  'notificationService'

  ($http, mySettings, notificationService) ->
    restrict: 'A'
    (scope, element, attrs) ->

      uploadedImages = []
      dropzone = undefined

      mySettings.fetch('dropzone').then (settings) ->
        max = (settings.maxFiles-1)
        availableIndexes = (index for index in [0..max])

        config =
          init: ->
            self = @
            $http.get('/upload').then (res) ->
              images = res.data
              angular.forEach images, (image) ->
                mockFile =
                  name: image.serverName
                  size: image.size
                  type: image.type
                  index: image.index
                self.options.addedfile.call self, mockFile
                self.options.thumbnail.call self, mockFile, image.url
                index = availableIndexes.indexOf image.index
                if index >= 0
                  availableIndexes.splice index, 1
                self.options.maxFiles -= 1
          addRemoveLinks : settings.addRemoveLinks
          maxFilesize: settings.maxFilesize
          maxFiles: settings.maxFiles
          uploadMultiple: false
          acceptedFiles: 'image/*'
          dictDefaultMessage: '<span class="text-center"><span class="font-lg visible-xs-block visible-sm-block visible-lg-block"><span class="font-lg"><i class="fa fa-caret-right text-danger"></i> Drop files <span class="font-xs">to upload</span></span><span>&nbsp&nbsp<h4 class="display-inline"> (Or Click)</h4></span>'
          dictResponseError: 'Error uploading file!'

        eventHandlers =
          sending: (file, xhr, formData) ->
            formData.append 'processType', 'upload'
            formData.append 'index', availableIndexes.shift()

          success: (file, res) ->
            uploadedImages.push
              name: file.name
              serverName: res.serverName
              index: res.index

          removedfile: (file) ->

            angular.forEach uploadedImages, (image) ->
              if image.name is file.name
                removeImage = image
                availableIndexes.push (parseInt image.index)

            # its an existing image loaded from the server
            if not removeImage? and not (file.status is 'error')
              removeImage = {}
              removeImage.serverName = file.name
              availableIndexes.push (parseInt file.index)

            if removeImage?
              $http.delete('/upload', params:
                serverName: removeImage.serverName).then (res) ->
                  if res.status isnt 200
                    notificationService.add
                      title: 'Warning'
                      content: 'There was an error while removing this image on the server. Please reload the page and try again.'
                      type: 'danger'
                      timeout: 5000
                  else
                    dropzone.options.maxFiles += 1

        # create a Dropzone for the element with the given options
        dropzone = new Dropzone(element[0], config)

        # bind the given event handlers
        angular.forEach eventHandlers, (handler, event) ->
          dropzone.on event, handler
          return

        return
]
