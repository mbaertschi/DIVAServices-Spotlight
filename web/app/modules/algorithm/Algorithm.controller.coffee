###
Controller AlgorithmPageController

* loads all images for this session into gallery
* loads information for this algorithm and processes inputs to be displayed
* handles validation states for highlighter and inputs
* handles socket.io messages if the given algorithm has changed
###
do ->
  'use strict'

  AlgorithmPageController = ($scope, $state, $stateParams, $timeout, socketPrepService, imagesPrepService, algorithmsPrepService, diaSocket, toastr) ->
    vm = @
    vm.algorithm = algorithmsPrepService.data.algorithm
    vm.highlighter = algorithmsPrepService.data.highlighter
    vm.validHighlighter = false
    vm.selection = null
    vm.inputs = algorithmsPrepService.data.inputs
    vm.model = algorithmsPrepService.data.model
    vm.infos = algorithmsPrepService.data.infos
    vm.images = imagesPrepService.images
    vm.selectedImage = null
    vm.state = 'select'

    $scope.$on 'set-highlighter-status', (event, data) ->
      $scope.safeApply -> vm.validHighlighter = data

    # set selected image
    vm.setSelectedImage = (image, fromBackModel) ->
      if not fromBackModel
        vm.validHighlighter = false
        vm.selection = null
      vm.state = 'highlight'
      vm.selectedImage = image

    # if we come from results view, set entry passed to $stateParams
    if $stateParams.backEntry?
      entry = $stateParams.backEntry.input
      vm.model = {}
      if entry.inputs? then angular.copy entry.inputs, vm.model
      vm.selection = entry.highlighter
      angular.forEach vm.images, (image) ->
        if image.url.split('?')[0] is entry.image.path.split('?')[0]
          vm.setSelectedImage image, true

    vm.goBack = ->
      $state.go 'algorithms'

    if socketPrepService.settings.run
      $scope.$on 'socket:update algorithms', (ev, algorithms) ->
        angular.forEach algorithms, (algorithm) ->
          if vm.algorithm?.url is algorithm.url
            toastr.warning 'This algorithm has been updated. Reloading the page in 5 seconds', 'Warning'
            $timeout (-> $state.go $state.$current, null, reload: true ), 5000

      $scope.$on 'socket:delete algorithms', (ev, algorithms) ->
        angular.forEach algorithms, (algorithm) ->
          if algorithm.url is vm.algorithm.url
            toastr.warning 'This algorithm has been removed. Going back to algorithms page in 5 seconds', 'Sorry'
            $timeout (-> $state.go 'algorithms'), 5000

      $scope.$on 'socket:error', (ev, data) ->
        toastr.error 'There was an error while fetching algorithms', 'Error'
        $state.go 'dashboard'

    vm

  angular.module('app.algorithm')
    .controller 'AlgorithmPageController', AlgorithmPageController

  AlgorithmPageController.$inject = [
    '$scope'
    '$state'
    '$stateParams'
    '$timeout'
    'socketPrepService'
    'imagesPrepService'
    'algorithmsPrepService'
    'diaSocket'
    'toastr'
  ]
