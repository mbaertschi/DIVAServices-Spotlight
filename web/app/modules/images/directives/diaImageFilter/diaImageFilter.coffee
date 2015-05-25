###
Directive diaImageFilter

* handles filters on filter page with camanJS
* updated images are stored on server
###
angular.module('app.images').directive 'diaImageFilter', [
  '$state'
  'diaStateManager'
  'diaImagesService'
  'toastr'
  '_'

  ($state, diaStateManager, diaImagesService, toastr, _) ->
    restrict: 'AC'
    templateUrl: 'modules/images/directives/diaImageFilter/template.html'

    link: (scope, element, attrs) ->
      caman = null
      busy = false
      changed = false
      image = $(element).find '.img-container > img'
      scope.rendering = false

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
          scope.safeApply -> scope.rendering = false
        , 300

      image.on 'load', ->
        caman = Caman '#caman-img'

      scope.filter = (filter, value) ->
        if scope.filters[filter]
          scope.safeApply -> scope.rendering = true
          scope.filters[filter].value = value
          render()

      scope.reset = ->
        caman.reset()

      scope.save = ->
        scope.safeApply -> scope.rendering = true
        base64Image = caman.toBase64()
        diaImagesService.put(base64Image, diaStateManager.image.name).then (res) ->
          scope.safeApply -> scope.rendering = false
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
        'vibrance':
          default: 0
          value: 0
        'saturation':
          default: 0
          value: 0
        'exposure':
          default: 0
          value: 0
        'contrast':
          default: 0
          value: 0
        'hue':
          default: 0
          value: 0
        'gamma':
          default: 1
          value: 1
        'sharpen':
          default: 0
          value: 0
]
