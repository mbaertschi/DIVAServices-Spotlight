do ->
  'use strict'

  DiaImageFilterController = ($scope, $state, diaStateManager, diaImagesService, toastr, _) ->
    self = @
    self.busy = false
    self.caman = null
    self.changed = false
    self.element = null
    $scope.currentImage = diaStateManager.image.src
    $scope.rendering = false

    @init = (element) ->
      self.element = element
      image = $(self.element).find '.img-container > img'
      image.on 'load', ->
        self.caman = Caman '#caman-img'

    render = _.throttle ->
      if self.busy
        self.changed = true
        return
      else
        self.changed = false

      self.busy = true
      self.caman.revert false
      for filter, settings of $scope.filters
        value = parseFloat settings.value, 10
        continue if value is 0

        self.caman[filter](value)

      self.caman.render ->
        self.busy = false
        render() if self.changed
        $scope.safeApply -> $scope.rendering = false
      , 300

    $scope.filter = (filter, value) ->
      if $scope.filters[filter]
        $scope.safeApply -> $scope.rendering = true
        $scope.filters[filter].value = value
        render()

    $scope.reset = ->
      self.caman.reset()

    $scope.save = ->
      $scope.safeApply -> $scope.rendering = true
      base64Image = self.caman.toBase64()
      diaImagesService.put(base64Image, diaStateManager.image.name).then (res) ->
        $scope.safeApply -> $scope.rendering = false
        if res.status isnt 200
          toastr.warning 'Image was not safed on server', 'Warning'
        else
          $scope.safeApply ->
            diaStateManager.reset()
            $state.go 'images.gallery'

    $scope.filters =
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


  angular.module('app.images')
    .controller 'DiaImageFilterController', DiaImageFilterController

  DiaImageFilterController.$inject = ['$scope', '$state', 'diaStateManager', 'diaImagesService', 'toastr', '_']
