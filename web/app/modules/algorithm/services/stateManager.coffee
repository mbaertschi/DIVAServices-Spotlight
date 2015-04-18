angular.module('app.algorithm').factory 'diaStateManager', [
  '$rootScope'

  ($rootScope) ->

    stateManager =
      state: 'upload'
      image: ''
      origin: null

    stateManager.switchState = (state, image, origin) ->
      @state = state
      if image? then @image = image else image = ''
      if origin? then @origin = origin else origin = ''
      @stateChange()

    stateManager.stateChange = ->
      $rootScope.$broadcast 'stateChange'

    stateManager
]
