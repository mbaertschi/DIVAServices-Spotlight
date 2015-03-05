angular.module('app').directive 'minifyMenu', [ ->

  restrict: 'A'
  link: (scope, element) ->
    $body = $('body')

    minifyMenu = ->
      $body.toggleClass 'minified'
      $body.removeClass 'hidden-menu'
      $('html').removeClass 'hidden-menu-mobile-lock'
      return

    element.on 'click', minifyMenu
    return
]
