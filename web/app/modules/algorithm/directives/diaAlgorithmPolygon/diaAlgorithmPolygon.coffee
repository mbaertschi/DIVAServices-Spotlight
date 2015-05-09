angular.module('app.algorithm').directive 'diaAlgorithmPolygon', [
  'diaHighlighterManager'

  (diaHighlighterManager) ->
    restrict: 'AE'

    link: (scope, element, attrs) ->
      image = canvas = raster = path = handle = segmentIndex = null
      initialized = false
      strokeColor = 'red'
      strokeWidth = 5
      fillColor = new paper.Color 1, 0, 0, 0.1

      scope.$watch 'selectedImage', ->
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
            view.viewSize = new Size(canvas.width, canvas.height)
            view.zoom = 1
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
          inverseScale = @.bounds.width / view.size.width
          strokeWidth = 5 * inverseScale
          view.zoom = scale
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
        handle = null
        point = event.point
        if path
          hitResult = path.hitTest point,
            segments: true
            fill: true
            stroke: true
            tolerance: 10
          if hitResult
            switch hitResult.type
              when 'segment'
                if (hitResult.segment.index is 0)
                  if path.closed
                    handle = hitResult.type
                    segmentIndex = hitResult.segment.index
                  else
                    path.closed = true
                    path.fillColor = fillColor
                    scope.setHighlighterStatus false
                else
                  handle = hitResult.type
                  segmentIndex = hitResult.segment.index
              when 'fill' then handle = hitResult.type
              when 'stroke'
                if path.closed then path.insert hitResult.location.index + 1, point
              else null
          else if path.closed
            path.remove()
            path = null
            diaHighlighterManager.path = null
            scope.setHighlighterStatus true

      mouseUp = (event) ->
        point = event.point
        unless path
          path = new Path()
          path.strokeColor = strokeColor
          path.strokeWidth = strokeWidth
          path.fullySelected = true
        if not path.closed and handle isnt 'segment'
          path.add point
        segmentIndex = null
        diaHighlighterManager.path = path

      mouseDrag = (event) ->
        x = event.delta.x
        y = event.delta.y
        switch handle
          when 'fill'
            # can only be true once the path is closed
            angular.forEach path.segments, (segment) ->
              segment.point.x += x
              segment.point.y += y
          when 'segment'
            # can only be true once the path is closed
            path.segments[segmentIndex].point.x += x
            path.segments[segmentIndex].point.y += y
]
