do ->
  'use strict'

  jarvisWidget = ->

    compile = (element) ->
      if element.data('widget-color')
        element.addClass 'jarviswidget-color-' + element.data('widget-color')
      element.find('.widget-body').prepend '<div class="jarviswidget-editbox"><input class="form-control" type="text"></div>'
      element.addClass 'jarviswidget jarviswidget-sortable'

    restrict 'A'
    compile: compile

  angular.module('app.widgets')
    .directive 'jarvisWidget', jarvisWidget
