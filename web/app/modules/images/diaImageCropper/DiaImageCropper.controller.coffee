do ->
  'use strict'

  DiaImageCropperController = ($scope, diaStateManager, diaImagesService, toastr) ->
    vm = @
    vm.currentImage = null
    vm.dataX = null
    vm.dataY = null
    vm.dataHeight = null
    vm.dataWidth = null
    vm.dataRotate = null
    vm.element = null
    vm.image = null
    vm.imageType = 'image/png'
    vm.rotationAngle = 45

    @init = (element) ->
      vm.element = element
      vm.currentImage = diaStateManager.image.src
      vm.image = $(vm.element).find '.img-container > img'

      options =
        aspectRatio: 16 / 9
        preview: '.img-preview'
        mouseWheelZoom: false
        crop: (data) ->
          $scope.safeApply ->
            vm.dataX = Math.round(data.x)
            vm.dataY = Math.round(data.y)
            vm.dataHeight = Math.round(data.height)
            vm.dataWidth = Math.round(data.width)
            vm.dataRotate = Math.round(data.rotate)
        built: ->
          vm.element.find('.cropper-container').on 'mousewheel', (event) ->
            if event.altKey
              if event.deltaY > 0 then factor = -0.1 else factor = 0.1
              vm.image.cropper 'zoom', factor
              event.preventDefault()

      vm.image.bind 'load', ->
        vm.image.cropper options

    vm.apply = (params) ->
      if params.method is 'skip'
        diaStateManager.switchState 'filtering', diaStateManager.image
      else
        if params.method is 'rotate' then params.option = vm.rotationAngle * params.option
        result = vm.image.cropper params.method, params.option
        if params.method is 'save'
          canvas = result.cropper('getCroppedCanvas')
          if not $(canvas).is 'canvas'
            diaStateManager.switchState 'filtering', diaStateManager.image
          else
            # save the base64Image on the server and go to next state
            base64Image = canvas.toDataURL vm.imageType
            diaImagesService.put(base64Image, diaStateManager.image.name).then (res) ->
              if res.status isnt 200
                toastr.warning 'Image was not safed on server. Please try again', 'Warning'
              else
                $scope.safeApply ->
                  image =
                    name: res.data.serverName
                    src: res.data.url
                  diaStateManager.switchState 'filtering', image

  angular.module('app.images')
    .controller 'DiaImageCropperController', DiaImageCropperController

  DiaImageCropperController.$inject = [
    '$scope'
    'diaStateManager'
    'diaImagesService'
    'toastr'
  ]
