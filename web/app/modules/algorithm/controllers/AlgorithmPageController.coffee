angular.module('app.algorithm').controller 'AlgorithmPageController', [
  '$scope'
  '$stateParams'
  'algorithmService'
  'toastr'
  'mySocket'
  '$state'
  '$timeout'
  'mySettings'
  '$window'
  'imagesService'
  '$sce'

  ($scope, $stateParams, algorithmService, toastr, mySocket, $state, $timeout, mySettings, $window, imagesService, $sce) ->
    $scope.algorithm = null
    $scope.images = []
    $scope.selectedImage = null
    $scope.highlighter = null
    $scope.invalidHighlighter = false
    $scope.inputs = []
    $scope.model = {}

    requestAlgorithm = ->
      host = $stateParams.host
      algorithm = $stateParams.algorithm
      url = 'http://' + host + '/' + algorithm

      if host? and algorithm?
        algorithmService.fetch(host, algorithm).then (res) ->
          algorithm = null
          try
            algorithm = JSON.parse res.data
          catch e
            toastr.error 'Could not parse algorithm information', 'Error'
          finally
            if algorithm
              $scope.algorithm = algorithm
              angular.forEach algorithm.input, (entry) ->
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
      else
        toastr.warning 'This algorithm does not have a correct url and can therefore not be loaded', 'Warning'

    requestAlgorithm()

    $scope.toggleCheckbox = (name) ->
      if $scope.model[name] then $scope.model[name] = 0 else $scope.model[name] = 1

    $scope.submit = ->
      console.log $scope.model

    $scope.setHighlighterStatus = (status) ->
      $scope.safeApply ->
        $scope.invalidHighlighter = status

    $scope.setSelectedImage = (image) ->
      $scope.selectedImage = image

    $scope.goBack = ->
      $state.go 'algorithms'

    requestImages = ->
      imagesService.fetch().then (res) ->
        $scope.images = res.data
      , (err) ->
        toastr.err err.statusText, err.status

    requestImages()

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
