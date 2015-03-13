angular.module('app.algorithm').directive 'smartDropzone', ->
  restrict: 'A'
  (scope, element, attrs) ->
    config = undefined
    dropzone = undefined
    config = scope[attrs.smartDropzone]
    # create a Dropzone for the element with the given options
    dropzone = new Dropzone(element[0], config.options)
    # bind the given event handlers
    angular.forEach config.eventHandlers, (handler, event) ->
      dropzone.on event, handler
      return
    return
