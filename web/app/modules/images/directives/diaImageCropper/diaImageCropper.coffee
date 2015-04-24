angular.module('app.images').directive 'diaImageCropper', [
  'toastr'
  'diaStateManager'
  'imagesService'

  (toastr, diaStateManager, imagesService) ->
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
        if params.method is 'rotate' then params.option = scope.rotationAngle * params.option
        if params.method is 'replace' then params.option = diaStateManager.origin
        if params.method is 'reload'
          params.method = 'replace'
          if diaStateManager.current['cropping']
            params.option = diaStateManager.current['cropping']
          else
            params.option = diaStateManager.origin
        result = image.cropper params.method, params.option
        if params.method is 'save'
          canvas = result.cropper('getCroppedCanvas')
          if not $(canvas).is 'canvas'
            # pass on original image
            diaStateManager.switchState 'filtering', image.src, image.src
          else
            # save the base64Image on the server and go to next state
            base64Image = canvas.toDataURL imageType
            imagesService.post(base64Image, 'croppedImage.png').then (res) ->
              #FIXME once base64Image storage is implemented correctly, use the
              #stored image in filter directive instead of the base64Image
              if res.status isnt 200
                toastr.warning 'Image was not safed on server. Continue with cached image', 'Warning'
              diaStateManager.switchState 'filtering', base64Image, { state: 'cropping', image: base64Image }
]
