###
Factory diaStateManager

* maintains an internal about which processing state (cropping / filtering)
  and which image is active
###
do ->
  'use strict'

  diaStateManager = ($rootScope) ->
    @state = null
    @image = null

    factory = ->
      switchState: switchState
      reset: reset

    switchState = (state, image) ->
      @state = state
      if image?
        $rootScope.safeApply =>
          image.src = image.src + '?' + new Date().getTime()
          @image = image
      else
        $rootScope.safeApply =>
          @image.src = @image.src + '?' + new Date().getTime()
      $rootScope.$broadcast 'stateChange'

    reset = ->
      @state = null
      @image = null

    factory()

  angular.module('app.images')
    .factory 'diaStateManager', diaStateManager

  diaStateManager.$inject = [
    '$rootScope'
  ]
