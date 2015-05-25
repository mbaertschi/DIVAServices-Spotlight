angular.module('app.algorithm').controller 'AlgorithmPageController', [
  '$scope'
  '$stateParams'
  'algorithmService'
  'toastr'
  'mySocket'
  '$state'
  'mySettings'
  '$window'
  'imagesService'
  '$sce'
  'diaHighlighterManager'
  'diaProcessingQueue'

  ($scope, $stateParams, algorithmService, toastr, mySocket, $state, mySettings, $window, imagesService, $sce, diaHighlighterManager, diaProcessingQueue) ->
    $scope.algorithm = null
    $scope.images = []
    $scope.selectedImage = null
    $scope.highlighter = null
    $scope.invalidHighlighter = false
    $scope.captchaEnabled = false
    $scope.invalideCaptcha = true
    $scope.invalidForm = false
    $scope.inputs = []
    $scope.model = {}
    $scope.state = 'select'
    $scope.id = null

    requestAlgorithm = ->
      $scope.id = $stateParams.id

      algorithmService.fetch($scope.id).then (res) ->
        $scope.algorithm = res.data
        angular.forEach $scope.algorithm.input, (entry) ->
          key = Object.keys(entry)[0]
          if key is 'highlighter'
            $scope.highlighter = entry.highlighter
          else
            $scope.inputs.push entry
            if key is 'select'
              $scope.model[entry[key].name] = entry[key].options.values[entry[key].options.default]
            else
              $scope.model[entry[key].name] = entry[key].options.default or null
      , (err) ->
        toastr.error 'Could not load algorithm', 'Error'

    requestAlgorithm()

    requestImages = ->
      imagesService.fetch().then (res) ->
        angular.forEach res.data, (image) ->
          image.thumbPath = image.thumbPath + '?' + new Date().getTime()
          image.url = image.url + '?' + new Date().getTime()
          @.push image
        , $scope.images
      , (err) ->
        toastr.err err.statusText, err.status

    requestImages()

    $scope.toggleCheckbox = (name) ->
      if $scope.model[name] then $scope.model[name] = 0 else $scope.model[name] = 1

    $scope.submit = ->
      if $scope.tasks >= 3
        toastr.warning 'You already have three algorithms in processing. Please wait for one to finish', 'Warning'
      else if $scope.captchaEnabled
        if not $scope.captcha.getCaptchaData().valid
          toastr.warning 'Please fill in captcha', 'Captcha Warning'
        else
          algorithmService.checkCaptcha($scope.captcha.getCaptchaData()).then (res) ->
            item =
              algorithm: $scope.algorithm
              image: $scope.selectedImage
              inputs: $scope.model
              highlighter: diaHighlighterManager.get()
            item.algorithm.id = $scope.id
            # toastr.info "Added #{$scope.algorithm.name} to processing queue", 'Success'
            diaProcessingQueue.push item
            $scope.captcha.refresh()
          , (err) ->
            $scope.captcha.refresh()
            if err.status is 403
              toastr.warning 'Invalid Captcha', err.status
            else
              toastr.error 'Captcha validation failed. Please try again', err.status
      else
        item =
          algorithm: $scope.algorithm
          image: $scope.selectedImage
          inputs: $scope.model
          highlighter: diaHighlighterManager.get()
        item.algorithm.id = $scope.id
        # toastr.info "Added #{$scope.algorithm.name} to processing queue", 'Success'
        diaProcessingQueue.push item

    $scope.setHighlighterStatus = (status) ->
      $scope.safeApply ->
        $scope.invalidHighlighter = status

    $scope.setFormValidity = (status) ->
      $scope.invalidForm = status

    $scope.setSelectedImage = (image) ->
      $scope.state = 'highlight'
      $scope.selectedImage = image
      $scope.submitted = false
      if $scope.captcha then $scope.captcha.refresh()

    $scope.goBack = ->
      $state.go 'algorithms'

    $scope.captchaOptions =
      imgPath: 'images/'
      captcha:
        numberOfImages: 5
        url: '/captcha'
      init: (captcha) ->
        $scope.captcha = captcha

    $scope.polygonDescription = $sce.trustAsHtml(
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

    $scope.rectangleDescription = $sce.trustAsHtml(
      """
      <p>Usage:</p>
      <p>- Click and drag mouse from top left to bottom right to span a new rectangle</p>
      <p>- Move the rectangle by clicking and dragging on its inner part</p>
      <p>- Resize the rectangle by clicking and dragging on of its corner points</p>
      <p>- Remove the rectangle and draw a new one by clicking outside of the rectangle</p>
      """
    )

    mySettings.fetch('socket').then (socket) ->
      if socket.run?
        $scope.$on 'socket:update algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            if $scope.algorithm?.url is algorithm.url
              toastr.warning 'This algorithm has been updated. Reloading the page in 5 seconds', 'Warning'
              $timeout (-> $window.location.reload()), 5000

        $scope.$on 'socket:delete algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            if algorithm.url is $scope.algorithm.url
              toastr.warning 'This algorithm has been removed. Going back to algorithms page in 5 seconds', 'Sorry'
              $timeout (-> $state.go 'algorithms'), 5000

        $scope.$on 'socket:error', (ev, data) ->
          toastr.error 'There was an error while fetching algorithms', 'Error'
          $state.go 'dashboard'

]
