angular.module('app.algorithm').factory 'diaPaperManager', [
  'diaHighlighterManager'

  (diaHighlighterManager) ->
    image = canvas = raster = path = null
    initialized = false

    initializeCanvas = (callback) ->
      img = new Image()
      img.src = image.url
      $(img).bind 'load', ->
        width = $('.canvas-wrapper')[0].clientWidth
        height = img.height * (width/img.width)
        canvas.width = width
        canvas.height = height
        callback()

    drawRaster = (scope) ->
      if project.layers[0]?
        project.layers[0].removeChildren()
      raster = new Raster
        source: image.url
        position: view.center
      raster.on 'load', ->
        scale = view.size.width / @.bounds.width
        inverseScale = @.bounds.width / view.size.width
        scope.strokeWidth = scope.strokeWidth * inverseScale
        view.zoom = scale
        view.update()

    initPaper = (scope) ->
      paper.install window
      paper.setup canvas
      tool = new Tool()
      tool.onMouseDown = scope.mouseDown
      tool.onMouseUp = scope.mouseUp
      tool.onMouseDrag = scope.mouseDrag
      tool.activate()
      initialized = true

    setup: (scope, element) ->
      # set highlighter status to invalid
      scope.setHighlighterStatus true
      image = scope.selectedImage
      canvas = element[0]
      diaHighlighterManager.reset()
      diaHighlighterManager.type = scope.highlighter
      if path
        path.remove()
        path = null
      initializeCanvas ->
        if initialized
          view.viewSize = new Size canvas.width, canvas.height
          view.zoom = 1
          view.update()
        else
          initPaper scope
        drawRaster scope

    reset: ->
      initialized = false
]
