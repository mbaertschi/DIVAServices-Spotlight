###
Directive diaAlgorithmRectangle

* manages rectangle selection for selectedImage
* uses diaPaperManager for setting up paperJS
* uses diaHighlighterManager for storing information about currently
  selected rectangle
* handles mouseDown, mouseUp and mouseDrag events
###
angular.module('app.algorithm').directive 'diaAlgorithmRectangle', [
  'diaHighlighterManager'
  'diaPaperManager'

  (diaHighlighterManager, diaPaperManager) ->
    restrict: 'AE'

    link: (scope, element, attrs) ->
      path = handle = null
      strokeColor = 'red'
      fillColor = new paper.Color 1, 0, 0, 0.1
      scope.strokeWidth = 5

      # tell diaPaperManager to re-initialize paperJS. This is executed
      # everytime the algorithm changes (but not when selectedImage changes)
      diaPaperManager.reset()

      scope.mouseDown = (event) ->
        handle = null
        point = event.point
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
            diaHighlighterManager.path = null
            scope.setHighlighterStatus true
            path = new Path.Rectangle from: point, to: point
            path.strokeColor = strokeColor
            path.strokeWidth = scope.strokeWidth
            path.fillColor = fillColor
        else
          diaHighlighterManager.path = null
          scope.setHighlighterStatus true
          path = new Path.Rectangle from: point, to: point
          path.strokeColor = strokeColor
          path.strokeWidth = scope.strokeWidth
          path.fillColor = fillColor

      scope.mouseUp = (event) ->
        path.fullySelected = true
        scope.setHighlighterStatus false
        diaHighlighterManager.path = path

      scope.mouseDrag = (event) ->
        x = event.delta.x
        y = event.delta.y
        switch handle
          # expand rectangle
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
            # move rectangle
            path.segments[0].point.x += x
            path.segments[0].point.y += y
            path.segments[1].point.x += x
            path.segments[1].point.y += y
            path.segments[2].point.x += x
            path.segments[2].point.y += y
            path.segments[3].point.x += x
            path.segments[3].point.y += y
          else
            # span rectangle
            path.segments[1].point.y += event.delta.y
            path.segments[2].point.x += event.delta.x
            path.segments[2].point.y += event.delta.y
            path.segments[3].point.x += event.delta.x

      # update paper settings if selectedImage has changed
      scope.$watch 'selectedImage', ->
        diaPaperManager.setup scope, element

  ]
