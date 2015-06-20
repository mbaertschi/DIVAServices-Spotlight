do ->
  'use strict'

  templateTool = ($sce, diaPaperManager) ->

    factory = ->
      initMouseEvents: initMouseEvents
      drawPath: drawPath
      setDescription: setDescription

    initMouseEvents = (vm) ->
      vm.tools =
        mouseDown: (event) ->
          console.log 'handle mouseDown'
        mouseUp: (event) ->
          console.log 'handle mouseUp'
        mouseDrag: (event) ->
          console.log 'handle mouseDrag'

    drawPath = (vm) ->
      console.log 'draw path given in vm.selection'

    setDescription = (vm) ->
      vm.description = $sce.trustAsHtml(
        """
        <p>Usage:</p>
        """
      )

    factory()

  angular.module('app.algorithm')
    .factory 'templateTool', templateTool

  templateTool.$inject = [
    '$sce'
    'diaPaperManager'
  ]
