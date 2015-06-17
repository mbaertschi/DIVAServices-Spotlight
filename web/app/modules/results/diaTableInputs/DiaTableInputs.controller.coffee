do ->
  'use strict'

  DiaTableInputsController = ($timeout, diaPaperScopeManager) ->
    vm = @
    vm.canvas = null
    vm.highlighter = vm.inputData?.highlighter or null
    vm.highlighters = vm.inputData?.highlighters or null
    vm.image = vm.inputData?.image.path or null
    vm.inputs = vm.inputData?.inputs or null
    vm.paperScope = null
    vm.strokeWidth = null
    vm.strokeColor = 'red'
    vm.fillColor = null
    vm.uuid = vm.inputData?.uuid or new Date
    vm.drag =
      x: 0
      y: 0
      state: false
    vm.delta =
      x: 0
      y: 0

    @init = (element) ->
      vm.element = element
      # wait for elements to be loaded in dom
      $timeout asyncLoadCanvas

    initializeCanvas = (callback) ->
      img = new Image
      img.src = vm.image
      $(img).bind 'load', ->
        width = $('.table-inputs')[0].clientWidth
        height = img.height * (width/img.width)
        vm.canvas.width = width
        vm.canvas.height = height
        callback()

    asyncLoadCanvas = ->
      vm.canvas = vm.element.find('#input-canvas')
      if vm.canvas.length
        if vm.paperScope
          vm.paperScope.paper.clear()
        vm.canvas = vm.canvas[0]
        initializeCanvas ->
          diaPaperScopeManager.setup 'input', vm

  angular.module('app.results')
    .controller 'DiaTableInputsController', DiaTableInputsController

  DiaTableInputsController.$inject = [
    '$timeout'
    'diaPaperScopeManager'
  ]
