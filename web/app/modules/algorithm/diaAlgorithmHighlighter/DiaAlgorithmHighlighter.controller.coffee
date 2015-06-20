do ->
  'use strict'

  DiaAlgorithmHighlighterController = ($scope, $injector, diaPaperManager, toastr) ->
    vm = @
    vm.strokeWidth = 3
    vm.strokeColor = 'red'
    vm.fillColor = new paper.Color 1, 0, 0, 0.1

    @init = (element) ->
      vm.element = element.find '#highlighter'
      vm.scope = $scope

      # tell diaPaperManager to re-initialize paperJS. This is executed
      # everytime the algorithm changes (but not when selectedImage changes)
      diaPaperManager.reset()

      # dynamicall load tool service
      validHighlighters = ['polygonTool', 'rectangleTool', 'circleTool']
      serviceName = vm.highlighter + 'Tool'
      if serviceName in validHighlighters and $injector.has serviceName
        toolService = $injector.get serviceName
        toolService.setDescription vm

        # init mouse event handlers
        toolService.initMouseEvents vm

        # update paper settings if selectedImage has changed
        $scope.$parent.$watch 'vm.selectedImage', ->
          diaPaperManager.resetPath()
          if vm.path then vm.path.remove()
          vm.path = null
          diaPaperManager.setup vm, ->
            if vm.selection? then toolService.drawPath vm
      else
        $scope.$emit 'invalid-highlighter'

  angular.module('app.algorithm')
    .controller 'DiaAlgorithmHighlighterController', DiaAlgorithmHighlighterController

  DiaAlgorithmHighlighterController.$inject = [
    '$scope'
    '$injector'
    'diaPaperManager'
  ]
