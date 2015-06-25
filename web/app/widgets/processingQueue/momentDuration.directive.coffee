do ->
  'use strict'

  momentDuration = ($interval) ->

    directive = ->
      restrict: 'A'
      link: link

    link = (scope, element, attrs) ->
      seconds = 0
      element.text('[ ' + seconds + ' seconds ]')

      updateText = ->
        seconds += 1
        if seconds is 1 then text = 'second' else text = 'seconds'
        element.text('[ ' + seconds + ' ' + text + ' ]')

      $interval updateText, 1000

    directive()

  angular.module('app.widgets')
    .directive 'momentDuration', momentDuration

  momentDuration.$inject = ['$interval']
