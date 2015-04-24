angular.module('app.images').directive 'diaImageFilter', [
  'diaStateManager'
  'imagesService'
  'toastr'
  '_'

  (diaStateManager, imagesService, toastr, _) ->
    restrict: 'AC'
    templateUrl: 'modules/images/directives/diaImageFilter/template.html'

    link: (scope, element, attrs) ->
      caman = null
      busy = false
      changed = false
      image = $(element).find '.img-container > img'

      render = _.throttle ->
        if busy
          changed = true
          return
        else
          changed = false

        busy = true
        caman.revert false
        for filter, settings of scope.filters
          value = parseFloat settings.value, 10
          continue if value is 0

          caman[filter](value)

        caman.render ->
          busy = false
          render() if changed
        , 300

      image.on 'load', ->
        caman = Caman '#caman-img'

      createCanvasFromImage = (source, callback) ->
        _image = new Image()
        _image.src = source
        scope.safeApply ->
          $(_image).on 'load', ->
            canvas = document.createElement('canvas')
            canvas.width = _image.width
            canvas.height = _image.height
            canvas.getContext('2d').drawImage _image, 0, 0
            callback canvas

      scope.filter = (filter, value) ->
        if scope.filters[filter]
          scope.filters[filter].value = value
          render()

      scope.reload = ->
        createCanvasFromImage diaStateManager.origin, (canvas) ->
          caman.replaceCanvas canvas

      scope.reset = ->
        caman.reset()

      scope.clear = ->
        if not diaStateManager.current['filtering']
          caman.reset()
        else
          createCanvasFromImage diaStateManager.current['filtering'], (canvas) ->
            caman.replaceCanvas canvas

      scope.save = ->
        base64Image = caman.toBase64()
        imagesService.post(base64Image, 'filteredImage.png').then (res) ->
          #FIXME once base64Image storage is implemented correctly, use the
          #stored image in filter directive instead of the base64Image
          if res.status isnt 200
            toastr.warning 'Image was not safed on server. Continue with cached image', 'Warning'
          diaStateManager.switchState 'highlighting', base64Image, { state: 'filtering', image: image[0].src }

      scope.filters =
        'brightness':
          default: 0
          value: 0
          min: -100
        'vibrance':
          default: 0
          value: 0
          min: -100
        'saturation':
          default: 0
          value: 0
          min: -100
        'exposure':
          default: 0
          value: 0
          min: -100
        'contrast':
          default: 0
          value: 0
          min: -100
        'hue':
          default: 0
          value: 0
          min: 0
        'gamma':
          default: 0
          value: 0
          min: 0
        'sharpen':
          default: 0
          value: 0
          min: 0
]
