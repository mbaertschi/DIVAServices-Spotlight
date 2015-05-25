###
Directive diaTableInputs

* renders inputs fields for all processed algorithms from diaProcessingQueue results
* if the input has a highlighter field, paperJS will be initialized and the
  path will be drawn on the canvas
###
angular.module('app.results').directive 'diaTableInputs', [
  '$timeout'

  ($timeout) ->
    restrict: 'A'
    scope:
      inputData: '='
    templateUrl: 'modules/results/directives/diaTableInputs/template.html'

    link: (scope, element, attrs) ->
      paperInput = canvas = path = null
      strokeColor = 'red'
      strokeWidth = null
      scope.highlighter = scope.inputData?.input.highlighter or null
      scope.inputs = scope.inputData?.input.inputs or null
      scope.image = scope.inputData?.image or null

      initializeCanvas = (callback) ->
        img = new Image
        img.src = scope.image.path
        $(img).bind 'load', ->
          width = $('.table-inputs')[0].clientWidth
          height = img.height * (width/img.width)
          canvas.width = width
          canvas.height = height
          callback()

      drawPath = (callback) ->
        path = new paperInput.Path
        path.strokeColor = strokeColor
        path.strokeWidth = scope.highlighter.strokeWidth
        angular.forEach scope.highlighter.segments, (segment) ->
          x = segment[0] * scope.highlighter.scaling
          y = segment[1] * scope.highlighter.scaling
          @.add new Point x, y
        , path
        path.closed = true
        callback()

      asyncLoadCanvas = ->
        canvas = element.find('#input-canvas')
        if path
          path.remove()
          path = null
        if canvas.length
          if paperInput
            paperInput.paper.clear()
          canvas = canvas[0]
          initializeCanvas ->
            paper.install window
            paperInput = new paper.PaperScope
            paperInput.setup canvas
            if paperInput.project.layers[0]?
              paperInput.project.layers[0].removeChildren()
            raster = new Raster
              source: scope.image.path
              position: paperInput.view.center
            raster.on 'load', ->
              scale = paperInput.view.size.width / @.bounds.width
              drawPath ->
                paperInput.view.zoom = scale
                paperInput.view.update()


      # wait for elements to be loaded in dom
      $timeout asyncLoadCanvas

]
