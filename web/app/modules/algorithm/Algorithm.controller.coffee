###
Controller AlgorithmPageController

* loads all images for this session into gallery
* loads information for this algorithm and processes inputs to be displayed
* handles validation states for highlighter and inputs
* handles socket.io messages if the given algorithm has changed
###
do ->
  'use strict'

  AlgorithmPageController = ($scope, $stateParams, $state, $window, $sce, diaSocket, diaSettings, diaAlgorithmService, diaHighlighterManager, diaProcessingQueue, toastr) ->
    vm = @
    vm.algorithm = null
    vm.images = []
    vm.selectedImage = null
    vm.highlighter = null
    vm.invalidHighlighter = false
    vm.captchaEnabled = false
    vm.invalideCaptcha = true
    vm.invalidForm = false
    vm.inputs = []
    vm.model = {}
    vm.state = 'select'
    vm.id = null

    # load algorithm information
    requestAlgorithm = ->
      vm.id = $stateParams.id

      diaAlgorithmService.fetch(vm.id).then (res) ->
        vm.algorithm = res.data

        # prepare input information
        angular.forEach vm.algorithm.input, (entry) ->
          key = Object.keys(entry)[0]
          if key is 'highlighter'
            # setup highlighter if there is one
            vm.highlighter = entry.highlighter
          else
            # setup inputs
            vm.inputs.push entry
            if key is 'select'
              vm.model[entry[key].name] = entry[key].options.values[entry[key].options.default]
            else
              vm.model[entry[key].name] = entry[key].options.default or null
      , (err) ->
        toastr.error 'Could not load algorithm', 'Error'

    requestAlgorithm()

    # load all images for this session
    requestImages = ->
      diaAlgorithmService.fetchImages().then (res) ->
        vm.images = res.data
      , (err) ->
        toastr.err err.statusText, err.status

    requestImages()

    # handle checkbox interactions
    vm.toggleCheckbox = (name) ->
      if vm.model[name] then vm.model[name] = 0 else vm.model[name] = 1

    # handle submit. If there are already 3 algorithms in process, abort and notify
    # user. If captcha is activated, check for valid input.
    vm.submit = ->
      if vm.tasks >= 3
        toastr.warning 'You already have three algorithms in processing. Please wait for one to finish', 'Warning'
      else if vm.captchaEnabled
        if not vm.captcha.getCaptchaData().valid
          toastr.warning 'Please fill in captcha', 'Captcha Warning'
        else
          algorithmService.checkCaptcha(vm.captcha.getCaptchaData()).then (res) ->
            item =
              algorithm: vm.algorithm
              image: vm.selectedImage
              inputs: vm.model
              highlighter: diaHighlighterManager.get()
            item.algorithm.id = vm.id
            diaProcessingQueue.push item
            vm.captcha.refresh()
          , (err) ->
            vm.captcha.refresh()
            if err.status is 403
              toastr.warning 'Invalid Captcha', err.status
            else
              toastr.error 'Captcha validation failed. Please try again', err.status
      else
        item =
          algorithm: vm.algorithm
          image: vm.selectedImage
          inputs: vm.model
          highlighter: diaHighlighterManager.get()
        item.algorithm.id = vm.id
        diaProcessingQueue.push item

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
    vm.setSelectedImage = (image) ->
      diaHighlighterManager.reset()
      vm.state = 'highlight'
      vm.selectedImage = image
      vm.submitted = false
      if vm.captcha then vm.captcha.refresh()

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
      <p>- Once the polygon is closed, you can add more points by clicking on itds edges</p>
      <p>- Once the polygon is closed, you can remove it and draw a new one by clicking outside of the polygon</p>
      """
    )

    vm.rectangleDescription = $sce.trustAsHtml(
      """
      <p>Usage:</p>
      <p>- Click and drag mouse from top left to bottom right to span a new rectangle</p>
      <p>- Move the rectangle by clicking and dragging on its inner part</p>
      <p>- Resize the rectangle by clicking and dragging on of its corner points</p>
      <p>- Remove the rectangle and draw a new one by clicking outside of the rectangle</p>
      """
    )

    diaSettings.fetch('socket').then (socket) ->
      if socket.run?
        $scope.$on 'socket:update algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            if vm.algorithm?.url is algorithm.url
              toastr.warning 'This algorithm has been updated. Reloading the page in 5 seconds', 'Warning'
              $timeout (-> $window.location.reload()), 5000

        $scope.$on 'socket:delete algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            if algorithm.url is vm.algorithm.url
              toastr.warning 'This algorithm has been removed. Going back to algorithms page in 5 seconds', 'Sorry'
              $timeout (-> $state.go 'algorithms'), 5000

        $scope.$on 'socket:error', (ev, data) ->
          toastr.error 'There was an error while fetching algorithms', 'Error'
          $state.go 'dashboard'

  angular.module('app.algorithm')
    .controller 'AlgorithmPageController', AlgorithmPageController

  AlgorithmPageController.$inject = ['$scope', '$stateParams', '$state', '$window', '$sce', 'diaSocket', 'diaSettings', 'diaAlgorithmService', 'diaHighlighterManager', 'diaProcessingQueue', 'toastr']
