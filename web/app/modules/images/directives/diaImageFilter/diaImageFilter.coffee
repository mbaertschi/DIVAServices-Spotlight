angular.module('app.images').directive 'diaImageFilter', [
  '$state'
  'diaStateManager'
  'imagesService'
  'toastr'
  '_'

  ($state, diaStateManager, imagesService, toastr, _) ->
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

      scope.filter = (filter, value) ->
        if scope.filters[filter]
          scope.filters[filter].value = value
          render()

      scope.reset = ->
        caman.reset()

      scope.save = ->
        base64Image = caman.toBase64()
        imagesService.post(base64Image, diaStateManager.image.name).then (res) ->
          if res.status isnt 200
            toastr.warning 'Image was not safed on server', 'Warning'
          else
            scope.safeApply ->
              diaStateManager.reset()
              $state.go 'images.gallery'

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
          min: -100
        'sharpen':
          default: 0
          value: 0
          min: 0
]
