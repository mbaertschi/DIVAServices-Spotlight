angular.module('app.images').factory 'diaStateManager', [
  '$rootScope'

  ($rootScope) ->

    stateManager =
      state: 'upload'
      image: null
      origin: null
      current: {}

    stateManager.switchState = (state, image, current, origin) ->
      @state = state
      if image? then @image = image
      if current? then @current[current.state] = current.image
      if origin? then @origin = origin
      @stateChange()

    stateManager.stateChange = ->
      $rootScope.$broadcast 'stateChange'

    stateManager.reset = ->
      @image = null
      @origin = null
      @current = {}

    stateManager
]
