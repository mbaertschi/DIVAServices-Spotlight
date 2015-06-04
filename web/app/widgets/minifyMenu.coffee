do ->
  'use strict'

  minifyMenu = ->

    link = (scope, element) ->
      $body = $('body')

      minifyMenu = ->
        if !$body.hasClass('hidden-menu')
          $body.toggleClass 'minified'
          $body.removeClass 'hidden-menu'
          $('html').removeClass 'hidden-menu-mobile-lock'

      element.on 'click', minifyMenu

    restrict: 'A'
    link: link

  angular.module('app.widgets')
    .directive 'minifyMenu', minifyMenu
