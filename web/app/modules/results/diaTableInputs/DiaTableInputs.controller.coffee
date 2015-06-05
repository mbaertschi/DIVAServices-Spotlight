do ->
  'use strict'

  DiaTableInputsController = ($timeout) ->
    vm = @
    vm.canvas = null
    vm.highlighter = vm.inputData?.input.highlighter or null
    vm.image = vm.inputData?.image or null
    vm.inputs = vm.inputData?.input.inputs or null
    vm.paperInput = null
    vm.path = null
    vm.strokeColor = 'red'

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
      vm.path = new vm.paperInput.Path
      vm.path.strokeColor = vm.strokeColor
      vm.path.strokeWidth = vm.highlighter.strokeWidth
      angular.forEach vm.highlighter.segments, (segment) ->
        x = segment[0] * vm.highlighter.scaling
        y = segment[1] * vm.highlighter.scaling
        @.add new Point x, y
      , vm.path
      vm.path.closed = true
      callback()

    asyncLoadCanvas = ->
      vm.canvas = vm.element.find('#input-canvas')
      if vm.path
        vm.path.remove()
        vm.path = null
      if vm.canvas.length
        if vm.paperInput
          vm.paperInput.paper.clear()
        vm.canvas = vm.canvas[0]
        initializeCanvas ->
          paper.install window
          vm.paperInput = new paper.PaperScope
          vm.paperInput.setup vm.canvas
          if vm.paperInput.project.layers[0]?
            vm.paperInput.project.layers[0].removeChildren()
          raster = new Raster
            source: vm.image.path
            position: vm.paperInput.view.center
          raster.on 'load', ->
            scale = vm.paperInput.view.size.width / @.bounds.width
            drawPath ->
              vm.paperInput.view.zoom = scale
              vm.paperInput.view.update()

  angular.module('app.results')
    .controller 'DiaTableInputsController', DiaTableInputsController

  DiaTableInputsController.$inject = [
    '$timeout'
  ]
