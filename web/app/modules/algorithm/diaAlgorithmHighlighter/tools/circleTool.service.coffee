do ->
  'use strict'

  circleTool = ($sce, diaPaperManager) ->

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
          if vm.handle is null
            diaPaperManager.resetPath()
            if vm.path then vm.path.remove()
            vm.scope.$emit 'set-highlighter-status', false
            vm.path = new Path.Circle center: point, radius: 1
            vm.path.strokeColor = vm.strokeColor
            vm.path.strokeWidth = vm.strokeWidth
            vm.path.fillColor = vm.fillColor

        mouseUp: (event) ->
          vm.path.fullySelected = true
          vm.scope.$emit 'set-highlighter-status', true
          diaPaperManager.set vm.path, 'circle'

        mouseDrag: (event) ->
          radius = vm.path.bounds.width / 2
          newRadius = vm.path.position.getDistance event.point
          factor = newRadius / radius
          switch vm.handle
            when 'fill'
              vm.path.position = event.point
            when 'left-center'
              vm.path.scale factor, vm.path.segments[2].point
            when 'top-center'
              vm.path.scale factor, vm.path.segments[3].point
            when 'right-center'
              vm.path.scale factor, vm.path.segments[0].point
            when 'bottom-center'
              vm.path.scale factor, vm.path.segments[1].point
            else
              vm.path.scale factor

    drawPath = (vm) ->
      center = new Point(vm.selection.position[0] , vm.selection.position[1])
      vm.path = new Path.Circle center: center, radius: vm.selection.radius
      vm.path.strokeColor = vm.strokeColor
      vm.path.strokeWidth = vm.strokeWidth
      vm.path.fillColor = vm.fillColor
      vm.path.fullySelected = true
      vm.path.scale vm.scale, [0, 0]
      vm.scope.$emit 'set-highlighter-status', true
      diaPaperManager.set vm.path, 'circle'

    setDescription = (vm) ->
      vm.description = $sce.trustAsHtml(
        """
        <p>Usage:</p>
        <p>- Click and drag mouse to span a new circle</p>
        <p>- Resize the circle by clicking and dragging one of its boundaries</p>
        <p>- Move the circle by clicking and dragging on its inner part</p>
        <p>- Remove the circle and draw a new one by clicking outside of the circle</p>
        """
      )

    factory()

  angular.module('app.algorithm')
    .factory 'circleTool', circleTool

  circleTool.$inject = [
    '$sce'
    'diaPaperManager'
  ]
