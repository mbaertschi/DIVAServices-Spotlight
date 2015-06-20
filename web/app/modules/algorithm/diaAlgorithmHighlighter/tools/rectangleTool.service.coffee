do ->
  'use strict'

  rectangleTool = ($sce, diaPaperManager) ->

    factory = ->
      initMouseEvents: initMouseEvents
      drawPath: drawPath
      setDescription: setDescription

    initMouseEvents = (vm) ->
      vm.tools =
        mouseDown: (event) ->
          vm.handle = null
          point = event.point
          if vm.path
            hitResult = vm.path.hitTest point,
              bounds: true
              fill: true
              tolerance: 10
            if hitResult
              switch hitResult.type
                when 'bounds' then vm.handle = hitResult.name
                when 'fill' then vm.handle = hitResult.type
                else vm.handle = null
            else
              vm.path.remove()
              diaPaperManager.resetPath()
              vm.scope.$emit 'set-highlighter-status', false
              vm.path = new Path.Rectangle from: point, to: point
              vm.path.strokeColor = vm.strokeColor
              vm.path.strokeWidth = vm.strokeWidth
              vm.path.fillColor = vm.fillColor
          else
            diaPaperManager.resetPath()
            vm.scope.$emit 'set-highlighter-status', false
            vm.path = new Path.Rectangle from: point, to: point
            vm.path.strokeColor = vm.strokeColor
            vm.path.strokeWidth = vm.strokeWidth
            vm.path.fillColor = vm.fillColor

        mouseUp: (event) ->
          vm.path.fullySelected = true
          vm.scope.$emit 'set-highlighter-status', true
          diaPaperManager.set vm.path, 'rectangle'

        mouseDrag: (event) ->
          x = event.delta.x
          y = event.delta.y
          switch vm.handle
            # expand rectangle
            when 'top-left'
              vm.path.segments[0].point.x += x
              vm.path.segments[0].point.y += y
              vm.path.segments[1].point.x += x
              vm.path.segments[3].point.y += y
            when 'bottom-left'
              vm.path.segments[0].point.x += x
              vm.path.segments[1].point.x += x
              vm.path.segments[1].point.y += y
              vm.path.segments[2].point.y += y
            when 'bottom-right'
              vm.path.segments[1].point.y += y
              vm.path.segments[2].point.x += x
              vm.path.segments[2].point.y += y
              vm.path.segments[3].point.x += x
            when 'top-right'
              vm.path.segments[0].point.y += y
              vm.path.segments[2].point.x += x
              vm.path.segments[3].point.x += x
              vm.path.segments[3].point.y += y
            when 'fill'
              # move rectangle
              vm.path.segments[0].point.x += x
              vm.path.segments[0].point.y += y
              vm.path.segments[1].point.x += x
              vm.path.segments[1].point.y += y
              vm.path.segments[2].point.x += x
              vm.path.segments[2].point.y += y
              vm.path.segments[3].point.x += x
              vm.path.segments[3].point.y += y
            else
              # span rectangle
              vm.path.segments[1].point.y += event.delta.y
              vm.path.segments[2].point.x += event.delta.x
              vm.path.segments[2].point.y += event.delta.y
              vm.path.segments[3].point.x += event.delta.x

    drawPath = (vm) ->
      vm.path = new Path
      vm.path.strokeColor = vm.strokeColor
      vm.path.strokeWidth = vm.strokeWidth
      vm.path.fillColor = vm.fillColor
      angular.forEach vm.selection.segments, (segment) ->
        x = segment[0]
        y = segment[1]
        @.add new Point x, y
      , vm.path
      vm.path.closed = true
      vm.path.fullySelected = true
      vm.path.scale vm.scale, [0, 0]
      vm.scope.$emit 'set-highlighter-status', true
      diaPaperManager.set vm.path, 'rectangle'

    setDescription = (vm) ->
      vm.description = $sce.trustAsHtml(
        """
        <p>Usage:</p>
        <p>- Click and drag mouse from top left to bottom right to span a new rectangle</p>
        <p>- Move the rectangle by clicking and dragging on its inner part</p>
        <p>- Resize the rectangle by clicking and dragging one of its corner points</p>
        <p>- Remove the rectangle and draw a new one by clicking outside of the rectangle</p>
        """
      )

    factory()

  angular.module('app.algorithm')
    .factory 'rectangleTool', rectangleTool

  rectangleTool.$inject = [
    '$sce'
    'diaPaperManager'
  ]
