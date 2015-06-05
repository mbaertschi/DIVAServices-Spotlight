do ->
  'use strict'

  DiaTableOutputsController = ($timeout) ->
    vm = @
    vm.canvas = null
    vm.highlighters = vm.outputData?.highlighters or null
    vm.image = vm.outputData?.image or null
    vm.output = vm.outputData?.output or null
    vm.paperOutput = null
    vm.strokeColor = 'red'

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

    drawPath = (callback) ->
      angular.forEach vm.highlighters, (highlighter) ->
        path = new vm.paperOutput.Path
        path.strokeColor = vm.strokeColor
        path.strokeWidth = 2
        angular.forEach highlighter.segments, (segment) ->
          x = segment[0]
          y = segment[1]
          @.add new Point x, y
        , path
        path.closed = true
      callback()

    asyncLoadCanvas = ->
      vm.canvas = vm.element.find('#output-canvas')
      if vm.canvas.length
        if path
          path.remove()
          path = null
        if vm.paperOutput
          vm.paperOutput.clear()
        vm.canvas = vm.canvas[0]
        initializeCanvas ->
          paper.install window
          vm.paperOutput = new paper.PaperScope
          vm.paperOutput.setup vm.canvas
          raster = new vm.paperOutput.Raster
            source: vm.image
            position: vm.paperOutput.view.center
          raster.on 'load', ->
            scale = vm.paperOutput.view.size.width / @.bounds.width
            drawPath ->
              vm.paperOutput.view.zoom = scale
              vm.paperOutput.view.update()

  angular.module('app.results')
    .controller 'DiaTableOutputsController', DiaTableOutputsController

  DiaTableOutputsController.$inject = [
    '$timeout'
  ]
