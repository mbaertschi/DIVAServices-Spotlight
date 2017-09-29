do ->
  'use strict'

  DiaTableOutputsController = ($timeout, diaImagesService, diaPaperScopeManager, toastr) ->
    vm = @
    vm.canvas = null
    vm.highlighters = vm.outputData?.highlighter or null
    vm.imageObject = vm.outputData?.visualization?.file? or null
    vm.image = vm.outputData?.visualization?.file?.url or null
    vm.output = vm.outputData?.output or null
    vm.paperScope = null
    vm.strokeWidth = null
    vm.strokeColor = 'red'
    vm.fillColor = null
    vm.uuid = vm.outputData?.uuid or new Date
    vm.withSVG = 0
    vm.drag =
      x: 0
      y: 0
      state: false
    vm.delta =
      x: 0
      y: 0

    vm.toggleSVG = ->
      if vm.withSVG then vm.withSVG = 0 else vm.withSVG = 1

    vm.saveImage = ->
      if vm.withSVG then image = vm.canvas.toDataURL() else image = vm.imageObject.dataUrl
      diaImagesService.saveImage(vm.imageObject, image).then (res) ->
        toastr.info 'Successfully saved image', 'Info'
      , (err) -> toastr.error 'Could not save image', 'Error'

    @init = (element) ->
      vm.element = element
      # wait for elements to be loaded in dom
      $timeout asyncLoadCanvas

    initializeCanvas = (callback) ->
      img = new Image
      img.src = vm.image
      $(img).bind 'load', ->
        width = $('.table-outputs')[0].clientWidth
        height = img.height * (width/img.width)
        vm.canvas.width = width
        vm.canvas.height = height
        callback()

    asyncLoadCanvas = ->
      vm.canvas = vm.element.find('#output-canvas')
      if vm.canvas.length
        if vm.paperScope
          vm.paperScope.clear()
        vm.canvas = vm.canvas[0]
        initializeCanvas ->
          diaPaperScopeManager.setup 'output', vm

  angular.module('app.results')
    .controller 'DiaTableOutputsController', DiaTableOutputsController

  DiaTableOutputsController.$inject = [
    '$timeout'
    'diaImagesService'
    'diaPaperScopeManager'
    'toastr'
  ]
