do ->
  'use strict'

  jarvisWidget = ->

    directive = ->
      restrict 'A'
      compile: compile

    compile = (element) ->
      if element.data('widget-color')
        element.addClass 'jarviswidget-color-' + element.data('widget-color')
      element.find('.widget-body').prepend '<div class="jarviswidget-editbox"><input class="form-control" type="text"></div>'
      element.addClass 'jarviswidget jarviswidget-sortable'

    directive()

  angular.module('app.widgets')
    .directive 'jarvisWidget', jarvisWidget
