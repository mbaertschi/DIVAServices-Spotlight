###
Controller AlgorithmPageController

* loads all images for this session into gallery
* loads information for this algorithm and processes inputs to be displayed
* handles validation states for highlighter and inputs
* handles socket.io messages if the given algorithm has changed
###
do ->
  'use strict'

  AlgorithmPageController = ($scope, $state, $stateParams, $sce, $timeout, socketPrepService, imagesPrepService, algorithmsPrepService, diaProcessingQueue, diaCaptchaService, diaModelBuilder, diaPaperManager, diaSocket, toastr) ->
    vm = @
    vm.algorithm = algorithmsPrepService.data.algorithm
    vm.highlighter = algorithmsPrepService.data.highlighter
    vm.selection = null
    vm.inputs = algorithmsPrepService.data.inputs
    vm.model = algorithmsPrepService.data.model
    vm.images = imagesPrepService.images
    vm.selectedImage = null
    vm.invalidHighlighter = false
    vm.invalideCaptcha = true
    vm.invalidForm = false
    vm.state = 'select'

    # enabled / disabled captcha
    vm.captchaEnabled = false

    # handle checkbox interactions
    vm.toggleCheckbox = (name) ->
      if vm.model[name] then vm.model[name] = 0 else vm.model[name] = 1

    # handle submit. If there are already 3 algorithms in process, abort and notify
    # user. If captcha is activated, check for valid input.
    vm.submit = ->
      if diaProcessingQueue.getQueue().length >= 3
        toastr.warning 'You already have three algorithms in processing. Please wait for one to finish', 'Warning'
      else if vm.captchaEnabled
        if not vm.captcha.getCaptchaData().valid
          toastr.warning 'Please fill in captcha', 'Captcha Warning'
        else
          diaCaptchaService.checkCaptcha(vm.captcha.getCaptchaData()).then (res) ->
            model = diaModelBuilder.prepareAlgorithmSendModel vm.algorithm, vm.selectedImage, vm.model, diaPaperManager.get()
            diaProcessingQueue.push model.item
            vm.captcha.refresh()
          , (err) ->
            vm.captcha.refresh()
            if err.status is 403
              toastr.warning 'Invalid Captcha', err.status
            else
              toastr.error 'Captcha validation failed. Please try again', err.status
      else
        model = diaModelBuilder.prepareAlgorithmSendModel vm.algorithm, vm.selectedImage, vm.model, diaPaperManager.get()
        diaProcessingQueue.push model.item

    # set the highlighter status to valid / invalid. This will be called
    # from child scopes
    vm.setHighlighterStatus = (status) ->
      $scope.safeApply ->
        vm.invalidHighlighter = status

    # set the form status to valid / invalid. This will be called from
    # child scopes
    vm.setFormValidity = (status) ->
      vm.invalidForm = status

    # set selected image
    vm.setSelectedImage = (image, fromBackModel) ->
      diaPaperManager.resetPath()
      if not fromBackModel then vm.selection = null
      vm.state = 'highlight'
      vm.selectedImage = image
      if vm.captcha then vm.captcha.refresh()

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

    vm.captchaOptions =
      imgPath: 'images/'
      captcha:
        numberOfImages: 5
        url: '/captcha'
      init: (captcha) ->
        vm.captcha = captcha

    vm.polygonDescription = $sce.trustAsHtml(
      """
      <p>Usage:</p>
      <p>- Click on image to add new points</p>
      <p>- Click and drag a point to move it</p>
      <p>- Click on the first point to close the polygon</p>
      <p>- Once the polygon is closed, you can move it by clicking and dragging on the inner part of it</p>
      <p>- Once the polygon is closed, you can add more points by clicking on its edges</p>
      <p>- Once the polygon is closed, you can remove it and draw a new one by clicking outside of the polygon</p>
      """
    )

    vm.rectangleDescription = $sce.trustAsHtml(
      """
      <p>Usage:</p>
      <p>- Click and drag mouse from top left to bottom right to span a new rectangle</p>
      <p>- Move the rectangle by clicking and dragging on its inner part</p>
      <p>- Resize the rectangle by clicking and dragging one of its corner points</p>
      <p>- Remove the rectangle and draw a new one by clicking outside of the rectangle</p>
      """
    )

    vm.circleDescription = $sce.trustAsHtml(
      """
      <p>Usage:</p>
      <p>- Click and drag mouse to span a new circle</p>
      <p>- Resize the circle by clicking and dragging one of its boundaries</p>
      <p>- Move the circle by clicking and dragging on its inner part</p>
      <p>- Remove the circle and draw a new one by clicking outside of the circle</p>
      """
    )

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
    '$sce'
    '$timeout'
    'socketPrepService'
    'imagesPrepService'
    'algorithmsPrepService'
    'diaProcessingQueue'
    'diaCaptchaService'
    'diaModelBuilder'
    'diaPaperManager'
    'diaSocket'
    'toastr'
  ]
