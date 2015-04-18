angular.module('app.algorithm').factory 'diaStateManager', [
  '$rootScope'

  ($rootScope) ->

    stateManager =
      state: 'upload'
      image: ''

    stateManager.switchState = (state, image) ->
      @state = state
      if image? then @image = image else image = ''
      @stateChange()

    stateManager.stateChange = ->
      $rootScope.$broadcast 'stateChange'

    stateManager
]
