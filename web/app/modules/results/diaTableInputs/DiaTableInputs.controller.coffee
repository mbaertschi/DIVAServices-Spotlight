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

    drawPath = (callback) ->
      if vm.highlighter.type is 'circle'
        center = new vm.paperInput.Point(vm.highlighter.position[0] - vm.strokeWidth, vm.highlighter.position[1] - vm.strokeWidth)
        path = new vm.paperInput.Path.Circle center: center, radius: vm.highlighter.radius
        path.strokeColor = vm.strokeColor
        path.strokeWidth = vm.strokeWidth
        path.fillColor = vm.fillColor
        callback()
      else
        path = new vm.paperInput.Path
        path.strokeColor = vm.strokeColor
        path.strokeWidth = vm.strokeWidth
        path.fillColor = vm.fillColor
        angular.forEach vm.highlighter.segments, (segment) ->
          x = segment[0] - path.strokeWidth
          y = segment[1] - path.strokeWidth
          @.add new Point x, y
        , path
        path.closed = true
        callback()

    asyncLoadCanvas = ->
      vm.canvas = vm.element.find('#input-canvas')
      if vm.canvas.length
        if vm.paperInput
          vm.paperInput.paper.clear()
        vm.canvas = vm.canvas[0]
        initializeCanvas ->
          paper.install window
          vm.paperInput = new paper.PaperScope
          vm.paperInput.setup vm.canvas
          vm.fillColor = new vm.paperInput.Color 1, 0, 0, 0.3
          raster = new vm.paperInput.Raster
            source: vm.image.path
            position: vm.paperInput.view.center
          raster.on 'load', ->
            scale = vm.paperInput.view.size.width / @.bounds.width
            inverseScale = @.bounds.width / vm.paperInput.view.size.width
            vm.strokeWidth = 4 * inverseScale
            drawPath ->
              vm.paperInput.view.zoom = scale
              vm.paperInput.view.update()

  angular.module('app.results')
    .controller 'DiaTableInputsController', DiaTableInputsController

  DiaTableInputsController.$inject = [
    '$timeout'
  ]
