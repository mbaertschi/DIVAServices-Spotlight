angular.module('app.algorithm').factory 'diaHighlighterManager', [
  ->
    highlighterManager =
      type: null
      path: null

    highlighterManager.reset = ->
      @type = null
      @path = null

    highlighterManager.get = ->
      if @path
        highlighter =
          strokeWidth: @path.strokeWidth
          strokeColor: @path.strokeColor
          position: @path.position
          scaling: @path.view.zoom
          closed: @path.closed
          pivot: @path.pivot
          segments: []
        angular.forEach @path.segments, (segment) ->
          @.push [segment.point.x, segment.point.y]
        , highlighter.segments
        highlighter
      else
        {}

    highlighterManager
]
