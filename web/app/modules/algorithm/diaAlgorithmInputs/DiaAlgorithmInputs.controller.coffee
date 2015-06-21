do ->
  'use strict'

  DiaAlgorithmInputsController = ($scope, diaModelBuilder, diaPaperManager, diaProcessingQueue, toastr) ->
    vm = @

    # if no highlighter is given, set this variable to true
    $scope.$watch 'vm.validHighlighter', ->
      if not vm.highlighter? then vm.validHighlighter = true

    # handle checkbox interactions
    vm.toggleCheckbox = (name) ->
      if vm.model[name] then vm.model[name] = 0 else vm.model[name] = 1

    # handle submit. If there are already 3 algorithms in process, abort and notify user
    vm.submit = ->
      if diaProcessingQueue.getQueue().length >= 3
        toastr.warning 'You already have three algorithms in processing. Please wait for one to finish', 'Warning'
      else
        if vm.highlighter? then path = diaPaperManager.get()
        model = diaModelBuilder.prepareAlgorithmSendModel vm.algorithm, vm.selectedImage, vm.model, path
        diaProcessingQueue.push model.item

    vm

  angular.module('app.algorithm')
    .controller 'DiaAlgorithmInputsController', DiaAlgorithmInputsController

  DiaAlgorithmInputsController.$inject = [
    '$scope'
    'diaModelBuilder'
    'diaPaperManager'
    'diaProcessingQueue'
    'toastr'
  ]
