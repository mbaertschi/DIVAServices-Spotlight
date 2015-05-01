angular.module('app.images').directive 'diaSmartDropzone', [
  '$http'
  'mySettings'
  'toastr'
  'diaStateManager'

  ($http, mySettings, toastr, diaStateManager) ->
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
                  src: image.url
                self.emit 'addedfile', mockFile
                self.emit 'thumbnail', mockFile, image.url
                self.emit 'success', mockFile
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
            formData.append 'index', availableIndexes.shift()

          success: (file, res) ->
            if res
              uploadedImages.push
                name: file.name
                serverName: res.serverName
                index: res.index
              imageSrc = res.url
            else
              imageSrc = file.src
            $(file.previewElement).on 'click', (event) ->
              diaStateManager.reset()
              diaStateManager.switchState 'cropping', imageSrc, null, imageSrc

          removedfile: (file) ->
            removeImage = null

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
                    toastr.warning 'There was an error while removing this image on the server. Please reload the page and try again', 'Warning'
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
