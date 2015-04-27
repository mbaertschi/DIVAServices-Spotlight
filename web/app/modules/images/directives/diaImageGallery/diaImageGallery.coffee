angular.module('app.images').directive 'diaImageGallery', [
  'imagesService'
  'toastr'
  'diaStateManager'

  (imagesService, toastr, diaStateManager) ->
    restrict: 'AC'
    templateUrl: 'modules/images/directives/diaImageGallery/template.html'

    link: (scope, element, attrs) ->

      IMAGE_WIDTH = 405

      imagesService.fetch().then (res) ->
        if not res.data.length
          scope.state = 'upload'
        else
          scope.images = []
          angular.forEach res.data, (image) ->
            img =
              id: image.index
              src: image.url
            scope.images.push img
      , (err) ->
        toastr.err err.statusText, err.status

      scope.edit = (image) ->
        diaStateManager.switchState 'cropping', image.src, image.src

      scope.scrollTo = (image, ind) ->
        scope.listposition = left: IMAGE_WIDTH * ind * -1 + 'px'
        scope.selected = image

]
