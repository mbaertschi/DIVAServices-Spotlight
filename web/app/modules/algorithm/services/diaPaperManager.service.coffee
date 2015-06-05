###
Factory diaPaperManager

* common service for setting up paperJS for given scope (vm) and element
* handles image and canvas scaling based on currently selected image
* this must be called by every highlighter
###
do ->
  'use strict'

  diaPaperManager = ->
    image = canvas = raster = path = null
    initialized = false

    factory = ->
      setup: setup
      reset: reset

    initializeCanvas = (callback) ->
      img = new Image()
      img.src = image.url
      $(img).bind 'load', ->
        width = $('.canvas-wrapper')[0].clientWidth
        height = img.height * (width/img.width)
        canvas.width = width
        canvas.height = height
        callback()

    drawRaster = (vm) ->
      if project.layers[0]?
        project.layers[0].removeChildren()
      raster = new Raster
        source: image.url
        position: view.center
      raster.on 'load', ->
        scale = view.size.width / @.bounds.width
        inverseScale = @.bounds.width / view.size.width
        vm.strokeWidth = vm.strokeWidth * inverseScale
        view.zoom = scale
        view.update()

    initPaper = (vm) ->
      paper.install window
      paper.setup canvas
      tool = new Tool()
      tool.onMouseDown = vm.mouseDown
      tool.onMouseUp = vm.mouseUp
      tool.onMouseDrag = vm.mouseDrag
      tool.activate()
      initialized = true

    setup = (vm) ->
      element = vm.element
      # set highlighter status to invalid
      vm.setHighlighterStatus status: true
      image = vm.selectedImage
      canvas = element[0]
      if path
        path.remove()
        path = null
      initializeCanvas ->
        if initialized
          view.viewSize = new Size canvas.width, canvas.height
          view.zoom = 1
          view.update()
        else
          initPaper vm
        drawRaster vm

    reset = ->
      initialized = false

    factory()

  angular.module('app.algorithm')
    .factory 'diaPaperManager', diaPaperManager
