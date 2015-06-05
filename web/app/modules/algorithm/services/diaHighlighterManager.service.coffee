###
Factory diaHighlighterManager

* keeps an internal state about currently selected highlighter
* exposes get method which prepares information about currently
  selected highlighter to be sent to server
###
do ->
  'use strict'

  diaHighlighterManager = ->
    @path = null

    factory = ->
      get: get
      set: set
      reset: reset

    reset = ->
      @path = null

    # we want to send only certain information to server
    get = ->
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
        angular.forEach @path.segments, (segment) ->
          x = segment.point.x * inverse
          y = segment.point.y * inverse
          @.push [x, y]
        , highlighter.segments
        highlighter
      else
        {}

    set = (path) ->
      @path = path

    factory()

  angular.module('app.algorithm')
    .factory 'diaHighlighterManager', diaHighlighterManager
