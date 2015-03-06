angular.module('app').filter 'iconFilter', ->

  (input) ->
    iconLookup =
      'success' : 'fa fa-check'
      'info'    : 'fa fa-info'
      'warning' : 'fa fa-warning'
      'danger'  : 'fa fa-times'

    icon = iconLookup[input]
    if icon? then return icon else return 'fa fa-info'
