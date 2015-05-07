angular.module('app.algorithm').directive 'diaAlgorithmRectangle', [
  ->
    restrict: 'AE'

    link: (scope, element, attrs) ->
      image = canvas = raster = path = handle = null
      initialized = false
      strokeColor = 'red'
      strokeWidth = 5
      fillColor = new paper.Color 0, 0, 0, 0

      scope.$watch 'selectedImage', ->
        image = scope.selectedImage
        canvas = element[0]
        initializeCanvas ->
          if initialized
            view.viewSize = new Size canvas.width, canvas.height
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
        toolRectangle = new Tool()
        toolRectangle.onMouseDown = mouseDown
        toolRectangle.onMouseUp = mouseUp
        toolRectangle.onMouseDrag = mouseDrag
        toolRectangle.activate()
        initialized = true

      mouseDown = (toolEvent) ->
        handle = null
        point = toolEvent.point
        if path
          hitResult = path.hitTest point,
            bounds: true
            fill: true
            tolerance: 10
          if hitResult
            switch hitResult.type
              when 'bounds' then handle = hitResult.name
              when 'fill' then handle = hitResult.type
              else handle = null
          else
            path.remove()
            path = new Path.Rectangle from: point, to: point
            path.strokeColor = strokeColor
            path.strokeWidth = strokeWidth
            path.fillColor = fillColor
        else
          path = new Path.Rectangle from: point, to: point
          path.strokeColor = strokeColor
          path.strokeWidth = strokeWidth
          path.fillColor = fillColor

      mouseUp = (toolEvent) ->
        path.fullySelected = true

      mouseDrag = (toolEvent) ->
        x = toolEvent.delta.x
        y = toolEvent.delta.y
        switch handle
          when 'top-left'
            path.segments[0].point.x += x
            path.segments[0].point.y += y
            path.segments[1].point.x += x
            path.segments[3].point.y += y
          when 'bottom-left'
            path.segments[0].point.x += x
            path.segments[1].point.x += x
            path.segments[1].point.y += y
            path.segments[2].point.y += y
          when 'bottom-right'
            path.segments[1].point.y += y
            path.segments[2].point.x += x
            path.segments[2].point.y += y
            path.segments[3].point.x += x
          when 'top-right'
            path.segments[0].point.y += y
            path.segments[2].point.x += x
            path.segments[3].point.x += x
            path.segments[3].point.y += y
          when 'fill'
            path.segments[0].point.x += x
            path.segments[0].point.y += y
            path.segments[1].point.x += x
            path.segments[1].point.y += y
            path.segments[2].point.x += x
            path.segments[2].point.y += y
            path.segments[3].point.x += x
            path.segments[3].point.y += y
          else
            path.segments[1].point.y += toolEvent.delta.y
            path.segments[2].point.x += toolEvent.delta.x
            path.segments[2].point.y += toolEvent.delta.y
            path.segments[3].point.x += toolEvent.delta.x
  ]
