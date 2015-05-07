angular.module('app.algorithm').directive 'diaAlgorithmPolygon', [
  ->
    restrict: 'AE'

    link: (scope, element, attrs) ->
      image = canvas = raster = null
      initialized = false

      scope.$watch 'selectedImage', ->
        image = scope.selectedImage
        canvas = element[0]
        initializeCanvas ->
          if initialized
            view.viewSize = new Size(canvas.width, canvas.height)
            view.update()
          else
            initPaper()
          drawRaster()

      initializeCanvas = (callback) ->
        img = new Image()
        img.src = image.url
        $(img).bind 'load', ->
          width = $('.canvas-wrapper')[0].clientWidth
          height = img.height * (width/img.width)
          canvas.width = width
          canvas.height = height
          callback()

      drawRaster = ->
        if project.layers[0]?
          project.layers[0].removeChildren()
        raster = new Raster
          source: image.url
          position: view.center
        raster.on 'load', ->
          scale = view.size.width / @.bounds.width
          raster.scale scale
          view.update()

      initPaper = ->
        paper.install window
        paper.setup canvas
        toolPolygon = new Tool()
        toolPolygon.onMouseDown = mouseDown
        toolPolygon.onMouseUp = mouseUp
        toolPolygon.onMouseDrag = mouseDrag
        toolPolygon.activate()
        initialized = true

      mouseDown = (event) ->
        console.log 'mouse down'

      mouseUp = (event) ->
        console.log 'mouse up'

      mouseDrag = (event) ->
        console.log 'mouse drag'
]
