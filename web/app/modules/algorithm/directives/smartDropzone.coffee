angular.module('app.algorithm').directive 'smartDropzone', ->
  restrict: 'A'
  (scope, element, attrs) ->
    dropzone = undefined
    config =
      addRemoveLinks : true
      maxFilesize: 1
      dictDefaultMessage: '<span class="text-center"><span class="font-lg visible-xs-block visible-sm-block visible-lg-block"><span class="font-lg"><i class="fa fa-caret-right text-danger"></i> Drop files <span class="font-xs">to upload</span></span><span>&nbsp&nbsp<h4 class="display-inline"> (Or Click)</h4></span>'
      dictResponseError: 'Error uploading file!'

    eventHandlers =
      sending: (file, xhr, formData) ->
      success: (file, response) ->

    # create a Dropzone for the element with the given options
    dropzone = new Dropzone(element[0], config)

    # bind the given event handlers
    angular.forEach eventHandlers, (handler, event) ->
      dropzone.on event, handler
      return
    return
