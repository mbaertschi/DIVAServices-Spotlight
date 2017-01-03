do ->
  'use strict'

  diaPaperScopeManager = (diaPanAndZoomManager) ->

    factory = ->
      setup: setup
      drawPath: drawPath
      drawCircle: drawCircle
      drawRectangle: drawRectangle
      drawPoint: drawPoint
      drawPolygon: drawPolygon
      drawArray: drawArray

    setup = (type, vm) ->
      vm.paperScope = new paper.PaperScope
      vm.paperScope.setup vm.canvas
      vm.fillColor = new vm.paperScope.Color 1, 0, 0, 0.3
      vm.strokeWidth = 3
      raster = new vm.paperScope.Raster
        source: vm.image
        position: vm.paperScope.view.center
      raster.on 'load', =>
        vm.scale = vm.paperScope.view.size.width / raster.bounds.width
        inverseScale = raster.bounds.width / vm.paperScope.view.size.width
        raster.scale vm.scale
        vm.paperScope.view.update()
        @drawPath vm, ->
          diaPanAndZoomManager.initPanAndZoom type, vm

    drawPath = (vm, callback) ->
      if vm.highlighters?
        angular.forEach vm.highlighters, (highlighter) =>
          switch Object.keys(highlighter)[0]
            when 'circle'
              @drawCircle vm, highlighter.circle
            when 'rectangle'
              @drawRectangle vm, highlighter.rectangle
            when 'point'
              @drawPoint vm, highlighter.point
            when 'polygon'
              @drawPolygon vm, highlighter.polygon
            when 'array'
              @drawArray vm, highlighter.array
            else null
        callback()
      else
        callback()

    drawCircle = (vm, circle) ->
      center = new vm.paperScope.Point circle.position
      path = new vm.paperScope.Path.Circle center: center, radius: circle.radius
      if circle.strokeColor?
        color = circle.strokeColor
        path.strokeColor = new vm.paperScope.Color color[0], color[1], color[2]
        path.fillColor = new vm.paperScope.Color color[0], color[1], color[2], 0.3
      else
        path.strokeColor = vm.strokeColor
        path.fillColor = vm.fillColor
      path.strokeWidth = vm.strokeWidth
      path.scale vm.scale, [0, 0]

    drawRectangle = (vm, rectangle) ->
      path = new vm.paperScope.Path
      if rectangle.strokeColor?
        color = rectangle.strokeColor
        path.strokeColor = new vm.paperScope.Color color[0], color[1], color[2]
        path.fillColor = new vm.paperScope.Color color[0], color[1], color[2], 0.3
      else
        path.strokeColor = vm.strokeColor
        path.fillColor = vm.fillColor
      path.strokeWidth = vm.strokeWidth
      angular.forEach rectangle.segments, (segment) ->
        x = segment[0]
        y = segment[1]
        @.add new vm.paperScope.Point x, y
      , path
      path.scale vm.scale, [0, 0]
      path.closed = true

    drawPoint = (vm, point) ->
      path = new vm.paperScope.Path.Circle center: point.position, radius: 2
      if point.strokeColor?
        color = point.strokeColor
        path.strokeColor = new vm.paperScope.Color color[0], color[1], color[2]
        path.fillColor = new vm.paperScope.Color color[0], color[1], color[2], 1
      else
        path.strokeColor = vm.strokeColor
        path.fillColor = 'red'
      path.strokeWidth = 1
      path.scale vm.scale, [0, 0]

    drawPolygon = (vm, polygon) ->
      path = new vm.paperScope.Path
      if polygon.strokeColor?
        color = polygon.strokeColor
        path.strokeColor = new vm.paperScope.Color color[0], color[1], color[2]
      else
        path.strokeColor = vm.strokeColor
      angular.forEach polygon.segments, (segment) ->
        x = segment[0]
        y = segment[1]
        @.add new vm.paperScope.Point x, y
      , path
      path.scale vm.scale, [0, 0]
      path.closed = false
    
    drawArray = (vm, array) ->
      path = new vm.paperScope.Path
      if array.options.strokeColor?
        color = array.options.strokeColor
        path.strokeColor = new vm.paperScope.Color color[0], color[1], color[2]
      else
        path.strokeColor = vm.strokeColor
      angular.forEach array.values, (values) ->
        x = values[0]
        y = values[1]
        @.add new vm.paperScope.Point x,y
      , path
      path.scale vm.scale, [0, 0]
      path.closed = false

    factory()
  angular.module('app.results')
    .factory 'diaPaperScopeManager', diaPaperScopeManager

  diaPaperScopeManager.$inject = ['diaPanAndZoomManager']
