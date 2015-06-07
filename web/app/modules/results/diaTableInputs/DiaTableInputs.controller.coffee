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
      path = new vm.paperInput.Path
      path.strokeColor = vm.strokeColor
      path.strokeWidth = vm.strokeWidth
      angular.forEach vm.highlighter.segments, (segment) ->
        x = segment[0]
        y = segment[1]
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
          raster = new Raster
            source: vm.image.path
            position: vm.paperInput.view.center
          raster.on 'load', ->
            vm.scale = vm.paperInput.view.size.width / @.bounds.width
            inverseScale = @.bounds.width / vm.paperInput.view.size.width
            vm.strokeWidth = 5 * inverseScale
            drawPath ->
              vm.paperInput.view.zoom = vm.scale
              vm.paperInput.view.update()

  angular.module('app.results')
    .controller 'DiaTableInputsController', DiaTableInputsController

  DiaTableInputsController.$inject = [
    '$timeout'
  ]
