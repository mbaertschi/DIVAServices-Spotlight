do ->
  'use strict'

  toggleMenu = ->

    link = (scope, element) ->
      $body = $('body')

      toggleMenu = ->
        if !$body.hasClass('menu-on-top')
          $('html').toggleClass 'hidden-menu-mobile-lock'
          $body.toggleClass 'hidden-menu'
          $body.removeClass 'minified'
        else if $body.hasClass('menu-on-top') and $body.hasClass('mobile-view-activated')
          $('html').toggleClass 'hidden-menu-mobile-lock'
          $body.toggleClass 'hidden-menu'
          $body.removeClass 'minified'

      element.on 'click', toggleMenu
      scope.$on 'requestToggleMenu', ->
        toggleMenu()

    restrict: 'A'
    link: link

  angular.module('app.widgets')
    .directive 'toggleMenu', toggleMenu
