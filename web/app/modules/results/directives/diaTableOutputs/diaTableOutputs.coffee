angular.module('app.results').directive 'diaTableOutputs', [
  '$timeout'

  ($timeout) ->
    restrict: 'A'
    scope:
      outputData: '='
    templateUrl: 'modules/results/directives/diaTableOutputs/template.html'

    link: (scope, element, attrs) ->
      paperOutput = canvas = null
      strokeColor = 'red'
      strokeWidth = null
      scope.highlighters = scope.outputData?.highlighters
      scope.output = scope.outputData?.output
      scope.image = scope.outputData?.image

      initializeCanvas = (callback) ->
        img = new Image
        img.src = scope.image
        $(img).bind 'load', ->
          width = $('.table-outputs')[0].clientWidth
          height = img.height * (width/img.width)
          canvas.width = width
          canvas.height = height
          callback()

      drawPath = (callback) ->
        angular.forEach scope.highlighters, (highlighter) ->
          path = new paperOutput.Path
          path.strokeColor = strokeColor
          path.strokeWidth = 2
          angular.forEach highlighter.segments, (segment) ->
            x = segment[0]
            y = segment[1]
            @.add new Point x, y
          , path
          path.closed = true
        callback()

      asyncLoadCanvas = ->
        canvas = element.find('#output-canvas')
        if canvas.length
          if path
            path.remove()
            path = null
          if paperOutput
            paperOutput.clear()
          canvas = canvas[0]
          initializeCanvas ->
            paper.install window
            paperOutput = new paper.PaperScope
            paperOutput.setup canvas
            raster = new paperOutput.Raster
              source: scope.image
              position: paperOutput.view.center
            raster.on 'load', ->
              scale = paperOutput.view.size.width / @.bounds.width
              drawPath ->
                paperOutput.view.zoom = scale
                paperOutput.view.update()


      # wait for elements to be loaded in dom
      $timeout asyncLoadCanvas
]
