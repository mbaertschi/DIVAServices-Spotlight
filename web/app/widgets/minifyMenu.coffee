do ->
  'use strict'

  minifyMenu = ->

    directive = ->
      restrict: 'A'
      link: link

    link = (scope, element) ->
      $body = $('body')
      minifyMenu = ->
        if !$body.hasClass('hidden-menu')
          $body.toggleClass 'minified'
          $body.removeClass 'hidden-menu'
          $('html').removeClass 'hidden-menu-mobile-lock'
      element.on 'click', minifyMenu

    directive()

  angular.module('app.widgets')
    .directive 'minifyMenu', minifyMenu
