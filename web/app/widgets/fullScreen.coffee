do ->
  'use strict'

  fullScreen = ->

    link = (scope, element) ->
      $body = $('body')

      toggleFullSceen = (e) ->
        if !$body.hasClass('full-screen')
          $body.addClass 'full-screen'
          if document.documentElement.requestFullscreen
            document.documentElement.requestFullscreen()
          else if document.documentElement.mozRequestFullScreen
            document.documentElement.mozRequestFullScreen()
          else if document.documentElement.webkitRequestFullscreen
            document.documentElement.webkitRequestFullscreen()
          else if document.documentElement.msRequestFullscreen
            document.documentElement.msRequestFullscreen()
        else
          $body.removeClass 'full-screen'
          if document.exitFullscreen
            document.exitFullscreen()
          else if document.mozCancelFullScreen
            document.mozCancelFullScreen()
          else if document.webkitExitFullscreen
            document.webkitExitFullscreen()

      element.on 'click', toggleFullSceen

    restrict: 'A'
    link: link

  angular.module('app.widgets')
    .directive 'fullScreen', fullScreen
