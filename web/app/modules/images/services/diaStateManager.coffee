###
Factory diaStateManager

* maintains an internal about which processing state (cropping / filtering)
  and which image is active
###
angular.module('app.images').factory 'diaStateManager', [
  '$rootScope'

  ($rootScope) ->

    stateManager =
      state: null
      image: null

    stateManager.switchState = (state, image) ->
      @state = state
      if image?
        $rootScope.safeApply =>
          image.src = image.src + '?' + new Date().getTime()
          @image = image
      else
        $rootScope.safeApply =>
          @image.src = @image.src + '?' + new Date().getTime()
      @stateChange()

    stateManager.stateChange = ->
      $rootScope.$broadcast 'stateChange'

    stateManager.reset = ->
      @state = null
      @image = null

    stateManager
]
