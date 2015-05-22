angular.module('app.algorithm').factory 'diaHighlighterManager', [
  ->
    highlighterManager =
      type: null
      path: null

    highlighterManager.reset = ->
      @type = null
      @path = null

    highlighterManager.get = ->
      if @path?.view?
        highlighter =
          strokeWidth: @path.strokeWidth
          strokeColor: @path.strokeColor
          position: @path.position
          scaling: @path.view.zoom
          closed: @path.closed
          pivot: @path.pivot
          segments: []
        inverse = 1 / highlighter.scaling
        console.log inverse
        angular.forEach @path.segments, (segment) ->
          x = segment.point.x * inverse
          y = segment.point.y * inverse
          @.push [x, y]
        , highlighter.segments
        highlighter
      else
        {}

    highlighterManager
]
