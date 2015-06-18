do ->
  'use strict'

  DiaAlgorithmRectangleController = ($scope, $sce, diaPaperManager) ->
    vm = @
    vm.element = null
    vm.handle = null
    vm.path = null
    vm.strokeColor = 'red'
    vm.fillColor = new paper.Color 1, 0, 0, 0.1
    vm.tools = {}
    vm.rectangleDescription = $sce.trustAsHtml(
      """
      <p>Usage:</p>
      <p>- Click and drag mouse from top left to bottom right to span a new rectangle</p>
      <p>- Move the rectangle by clicking and dragging on its inner part</p>
      <p>- Resize the rectangle by clicking and dragging one of its corner points</p>
      <p>- Remove the rectangle and draw a new one by clicking outside of the rectangle</p>
      """
    )

    @init = (element) ->
      vm.element = element.find '#rectangle'

      # tell diaPaperManager to re-initialize paperJS. This is executed
      # everytime the algorithm changes (but not when selectedImage changes)
      diaPaperManager.reset()

      # init mouse event handlers
      setupMouseEvents()

      # update paper settings if selectedImage has changed
      $scope.$parent.$watch 'vm.selectedImage', ->
        diaPaperManager.resetPath()
        if vm.path then vm.path.remove()
        vm.path = null
        diaPaperManager.setup vm, ->
          if vm.selection? then drawPath()

    drawPath = ->
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
      $scope.$emit 'set-highlighter-status', true
      diaPaperManager.set vm.path, 'rectangle'

    setupMouseEvents = ->

      vm.tools.mouseDown = (event) ->
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
            $scope.$emit 'set-highlighter-status', false
            vm.path = new Path.Rectangle from: point, to: point
            vm.path.strokeColor = vm.strokeColor
            vm.path.strokeWidth = vm.strokeWidth
            vm.path.fillColor = vm.fillColor
        else
          diaPaperManager.resetPath()
          $scope.$emit 'set-highlighter-status', false
          vm.path = new Path.Rectangle from: point, to: point
          vm.path.strokeColor = vm.strokeColor
          vm.path.strokeWidth = vm.strokeWidth
          vm.path.fillColor = vm.fillColor

      vm.tools.mouseUp = (event) ->
        vm.path.fullySelected = true
        $scope.$emit 'set-highlighter-status', true
        diaPaperManager.set vm.path, 'rectangle'

      vm.tools.mouseDrag = (event) ->
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

  angular.module('app.algorithm')
    .controller 'DiaAlgorithmRectangleController', DiaAlgorithmRectangleController

  DiaAlgorithmRectangleController.$inject = [
    '$scope'
    '$sce'
    'diaPaperManager'
  ]
