do ->
  'use strict'

  DiaTableInputsController = ($timeout) ->
    vm = @
    vm.canvas = null
    vm.highlighter = vm.inputData?.highlighter or null
    vm.image = vm.inputData?.image or null
    vm.inputs = vm.inputData?.inputs or null
    vm.paperInput = null
    vm.strokeWidth = null
    vm.strokeColor = 'red'
    vm.fillColor = null

    @init = (element) ->
      vm.element = element
      # wait for elements to be loaded in dom
      $timeout asyncLoadCanvas

    initializeCanvas = (callback) ->
      img = new Image
      img.src = vm.image.path
      $(img).bind 'load', ->
        width = $('.table-inputs')[0].clientWidth
        height = img.height * (width/img.width)
        vm.canvas.width = width
        vm.canvas.height = height
        callback()

    drawPath = ->
      if vm.highlighter.type is 'circle'
        center = new vm.paperInput.Point(vm.highlighter.position[0] - vm.strokeWidth, vm.highlighter.position[1] - vm.strokeWidth)
        path = new vm.paperInput.Path.Circle center: center, radius: vm.highlighter.radius
        path.strokeColor = vm.strokeColor
        path.strokeWidth = vm.strokeWidth
        path.fillColor = vm.fillColor
        path.scale vm.scale, [0, 0]
      else
        path = new vm.paperInput.Path
        path.strokeColor = vm.strokeColor
        path.strokeWidth = vm.strokeWidth
        path.fillColor = vm.fillColor
        angular.forEach vm.highlighter.segments, (segment) ->
          x = segment[0] #- path.strokeWidth
          y = segment[1] #- path.strokeWidth
          @.add new vm.paperInput.Point x, y
        , path
        path.closed = true
        path.scale vm.scale, [0, 0]

    asyncLoadCanvas = ->
      vm.canvas = vm.element.find('#input-canvas')
      if vm.canvas.length
        if vm.paperInput
          vm.paperInput.paper.clear()
        vm.canvas = vm.canvas[0]
        initializeCanvas ->
          vm.paperInput = new paper.PaperScope
          vm.paperInput.setup vm.canvas
          vm.fillColor = new vm.paperInput.Color 1, 0, 0, 0.3
          raster = new vm.paperInput.Raster
            source: vm.image.path
            position: vm.paperInput.view.center
          raster.on 'load', ->
            vm.scale = vm.paperInput.view.size.width / @.bounds.width
            inverseScale = @.bounds.width / vm.paperInput.view.size.width
            vm.strokeWidth = 4 * vm.scale
            raster.scale vm.scale
            vm.paperInput.view.update()
            drawPath()

  angular.module('app.results')
    .controller 'DiaTableInputsController', DiaTableInputsController

  DiaTableInputsController.$inject = [
    '$timeout'
  ]
