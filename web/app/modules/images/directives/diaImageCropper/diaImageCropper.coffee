###
Directive diaImageCropper

* handles image croppy and rotating
* sends updated images to server
###
angular.module('app.images').directive 'diaImageCropper', [
  'toastr'
  'diaStateManager'
  'diaImagesService'

  (toastr, diaStateManager, diaImagesService) ->
    restrict: 'AC'
    templateUrl: 'modules/images/directives/diaImageCropper/template.html'

    link: (scope, element, attrs) ->
      imageType = 'image/png'
      image = $(element).find '.img-container > img'
      scope.rotationAngle = 45

      options =
        aspectRatio: 16 / 9
        preview: '.img-preview'
        crop: (data) ->
          scope.safeApply ->
            scope.dataX = Math.round(data.x)
            scope.dataY = Math.round(data.y)
            scope.dataHeight = Math.round(data.height)
            scope.dataWidth = Math.round(data.width)
            scope.dataRotate = Math.round(data.rotate)

      image.bind 'load', ->
        image.cropper options

      scope.apply = (params) ->
        if params.method is 'skip'
          diaStateManager.switchState 'filtering', diaStateManager.image
        else
          if params.method is 'rotate' then params.option = scope.rotationAngle * params.option
          result = image.cropper params.method, params.option
          if params.method is 'save'
            canvas = result.cropper('getCroppedCanvas')
            if not $(canvas).is 'canvas'
              diaStateManager.switchState 'filtering', diaStateManager.image
            else
              # save the base64Image on the server and go to next state
              base64Image = canvas.toDataURL imageType
              diaImagesService.put(base64Image, diaStateManager.image.name).then (res) ->
                if res.status isnt 200
                  toastr.warning 'Image was not safed on server. Please try again', 'Warning'
                else
                  scope.safeApply ->
                    image =
                      name: res.data.serverName
                      src: res.data.url
                    diaStateManager.switchState 'filtering', image
]
