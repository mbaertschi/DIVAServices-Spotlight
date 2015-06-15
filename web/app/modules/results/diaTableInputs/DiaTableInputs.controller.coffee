do ->
  'use strict'

  DiaTableInputsController = ($timeout, diaPanAndZoomManager) ->
    vm = @
    vm.canvas = null
    vm.highlighter = vm.inputData?.highlighter or null
    vm.image = vm.inputData?.image or null
    vm.inputs = vm.inputData?.inputs or null
    vm.paperInput = null
    vm.strokeWidth = null
    vm.strokeColor = 'red'
    vm.fillColor = null
    vm.uuid = vm.inputData?.uuid or new Date
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
      img.src = vm.image.path
      $(img).bind 'load', ->
        width = $('.table-inputs')[0].clientWidth
        height = img.height * (width/img.width)
        vm.canvas.width = width
        vm.canvas.height = height
        callback()

    drawPath = (callback) ->
      if vm.highlighter?
        if vm.highlighter.type is 'circle'
          center = new vm.paperInput.Point(vm.highlighter.position[0] , vm.highlighter.position[1])
          path = new vm.paperInput.Path.Circle center: center, radius: vm.highlighter.radius
          path.strokeColor = vm.strokeColor
          path.strokeWidth = vm.strokeWidth
          path.fillColor = vm.fillColor
          path.scale vm.scale, [0, 0]
          callback()
        else
          path = new vm.paperInput.Path
          path.strokeColor = vm.strokeColor
          path.strokeWidth = vm.strokeWidth
          path.fillColor = vm.fillColor
          angular.forEach vm.highlighter.segments, (segment) ->
            x = segment[0]
            y = segment[1]
            @.add new vm.paperInput.Point x, y
          , path
          path.closed = true
          path.scale vm.scale, [0, 0]
          callback()
      else
        callback()

    initPanAndZoom = ->
      diaPanAndZoomManager.add 'input', vm.uuid, vm.paperInput
      vm.element.on 'mouseenter', (event) ->
        diaPanAndZoomManager.activate vm.uuid
      vm.element.on 'mouseleave', ->
        diaPanAndZoomManager.reset vm.uuid
      vm.element.on 'mousewheel', (event) ->
        if event.shiftKey
          diaPanAndZoomManager.changeCenter vm.uuid, event.deltaX, event.deltaY, event.deltaFactor
          event.preventDefault()
        else if event.altKey
          mousePosition = new vm.paperInput.Point event.offsetX, event.offsetY
          viewPosition = vm.paperInput.view.viewToProject mousePosition
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
            drawPath ->
              initPanAndZoom()

  angular.module('app.results')
    .controller 'DiaTableInputsController', DiaTableInputsController

  DiaTableInputsController.$inject = [
    '$timeout'
    'diaPanAndZoomManager'
  ]
