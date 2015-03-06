angular.module('app').filter 'colorFilter', ->

  (input) ->
    colorLookup =
      'success' : '#739e73'
      'info'    : '#57889c'
      'warning' : '#c79121'
      'danger'  : '#a90329'

    color = colorLookup[input]
    if color? then return color else return '#57889c'
