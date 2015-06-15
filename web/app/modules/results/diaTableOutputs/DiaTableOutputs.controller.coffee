do ->
  'use strict'

  DiaTableOutputsController = ($timeout, diaPanAndZoomManager) ->
    vm = @
    vm.canvas = null
    vm.highlighters = vm.outputData?.highlighters or null
    vm.image = vm.outputData?.image or null
    vm.output = vm.outputData?.output or null
    vm.paperOutput = null
    vm.strokeWidth = null
    vm.strokeColor = 'red'
    vm.fillColor = null
    vm.uuid = vm.outputData?.uuid or new Date
    vm.drag =
      x: 0
      y: 0
      state: false
    vm.delta =
      x: 0
      y: 0

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
      if vm.highlighters?
        angular.forEach vm.highlighters, (highlighter) ->
          if highlighter.circle?
            circle = highlighter.circle
            center = new vm.paperOutput.Point circle.position
            path = new vm.paperOutput.Path.Circle center: center, radius: circle.radius
            if circle.strokeColor?
              color = circle.strokeColor
              path.strokeColor = new vm.paperOutput.Color color[0], color[1], color[2]
              path.fillColor = new vm.paperOutput.Color color[0], color[1], color[2], 0.3
            else
              path.strokeColor = vm.strokeColor
              path.fillColor = vm.fillColor
            path.strokeWidth = vm.strokeWidth
            path.scale vm.scale, [0, 0]
          else if highlighter.rectangle?
            rectangle = highlighter.rectangle
            path = new vm.paperOutput.Path
            if rectangle.strokeColor?
              color = rectangle.strokeColor
              path.strokeColor = new vm.paperOutput.Color color[0], color[1], color[2]
              path.fillColor = new vm.paperOutput.Color color[0], color[1], color[2], 0.3
            else
              path.strokeColor = vm.strokeColor
              path.fillColor = vm.fillColor
            path.strokeWidth = vm.strokeWidth
            angular.forEach rectangle.segments, (segment) ->
              x = segment[0]
              y = segment[1]
              @.add new vm.paperOutput.Point x, y
            , path
            path.scale vm.scale, [0, 0]
            path.closed = true
          else if highlighter.point?
            point = highlighter.point
            path = new vm.paperOutput.Path.Circle center: point.position, radius: 2
            if point.strokeColor?
              color = point.strokeColor
              path.strokeColor = new vm.paperOutput.Color color[0], color[1], color[2]
              path.fillColor = new vm.paperOutput.Color color[0], color[1], color[2], 1
            else
              path.strokeColor = vm.strokeColor
              path.fillColor = 'red'
            path.strokeWidth = 1
            path.scale vm.scale, [0, 0]
          else if highlighter.line?
            line = highlighter.line
            path = new vm.paperOutput.Path
            if line.strokeColor?
              color = line.strokeColor
              path.strokeColor = new vm.paperOutput.Color color[0], color[1], color[2]
            else
              path.strokeColor = vm.strokeColor
            angular.forEach line.segments, (segment) ->
              x = segment[0]
              y = segment[1]
              @.add new vm.paperOutput.Point x, y
            , path
            path.scale vm.scale, [0, 0]
            path.closed = false
        callback()
      else
        callback()

    initPanAndZoom = ->
      diaPanAndZoomManager.add 'output', vm.uuid, vm.paperOutput
      vm.element.on 'mouseenter', (event) ->
        diaPanAndZoomManager.activate vm.uuid
      vm.element.on 'mouseleave', ->
        diaPanAndZoomManager.reset vm.uuid
      vm.element.on 'mousewheel', (event) ->
        if event.shiftKey
          diaPanAndZoomManager.changeCenter vm.uuid, event.deltaX, event.deltaY, event.deltaFactor
          event.preventDefault()
        else if event.altKey
          mousePosition = new vm.paperOutput.Point event.offsetX, event.offsetY
          viewPosition = vm.paperOutput.view.viewToProject mousePosition
          diaPanAndZoomManager.changeZoom vm.uuid, event.deltaY, viewPosition
          event.preventDefault()
      vm.element.on 'mousedown', (event) ->
        vm.drag.x = event.pageX
        vm.drag.y = event.pageY
        vm.drag.state = true
      vm.element.on 'mouseup', ->
        vm.drag.state = false
      vm.element.on 'mousemove', (event) ->
        if vm.drag.state
          vm.delta.x = event.pageX - vm.drag.x
          vm.delta.y = event.pageY - vm.drag.y
          vm.drag.x = event.pageX
          vm.drag.y = event.pageY
          diaPanAndZoomManager.changeCenter vm.uuid, -vm.delta.x, vm.delta.y, 1

    asyncLoadCanvas = ->
      vm.canvas = vm.element.find('#output-canvas')
      if vm.canvas.length
        if vm.paperOutput
          vm.paperOutput.clear()
        vm.canvas = vm.canvas[0]
        initializeCanvas ->
          vm.paperOutput = new paper.PaperScope
          vm.paperOutput.setup vm.canvas
          vm.fillColor = new vm.paperOutput.Color 1, 0, 0, 0.3
          raster = new vm.paperOutput.Raster
            source: vm.image
            position: vm.paperOutput.view.center
          raster.on 'load', ->
            vm.scale = vm.paperOutput.view.size.width / @.bounds.width
            inverseScale = @.bounds.width / vm.paperOutput.view.size.width
            vm.strokeWidth = 4 * vm.scale
            raster.scale vm.scale
            vm.paperOutput.view.update()
            drawPath ->
              initPanAndZoom()

  angular.module('app.results')
    .controller 'DiaTableOutputsController', DiaTableOutputsController

  DiaTableOutputsController.$inject = [
    '$timeout'
    'diaPanAndZoomManager'
  ]
