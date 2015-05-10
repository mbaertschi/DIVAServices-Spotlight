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
          segments: @path.segments
        highlighter
      else
        {}

    highlighterManager
]
