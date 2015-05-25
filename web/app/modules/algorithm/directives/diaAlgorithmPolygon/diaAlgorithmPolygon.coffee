###
Directive diaAlgorithmPolygon

* manages polygon selection for selectedImage
* uses diaPaperManager for setting up paperJS
* uses diaHighlighterManager for storing information about currently
  selected polygon
* handles mouseDown, mouseUp and mouseDrag events
###
angular.module('app.algorithm').directive 'diaAlgorithmPolygon', [
  'diaHighlighterManager'
  'diaPaperManager'

  (diaHighlighterManager, diaPaperManager) ->
    restrict: 'AE'

    link: (scope, element, attrs) ->
      path = handle = segmentIndex = null
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

      scope.mouseUp = (event) ->
        point = event.point
        unless path
          path = new Path()
          path.strokeColor = strokeColor
          path.strokeWidth = scope.strokeWidth
          path.fullySelected = true
        if not path.closed and handle isnt 'segment'
          path.add point
        segmentIndex = null
        diaHighlighterManager.path = path

      scope.mouseDrag = (event) ->
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

      # update paper settings if selectedImage has changed
      scope.$watch 'selectedImage', ->
        diaPaperManager.setup scope, element
]
