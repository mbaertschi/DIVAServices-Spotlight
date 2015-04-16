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

  ($scope, $stateParams, algorithmService, toastr, mySocket, $state, $timeout, mySettings, $window) ->
    $scope.algorithm = null

    requestAlgorithm = ->
      host = $stateParams.host
      algorithm = $stateParams.algorithm
      url = 'http://' + host + '/' + algorithm

      if host? and algorithm?
        algorithmService.fetch(host, algorithm).then (res) ->
          try
            $scope.algorithm = JSON.parse res.data
          catch e
            toastr.error 'Could not parse algorithm information', 'Error'
        , (err) ->
          toastr.error 'Could not load algorithm', 'Error'
      else
        toastr.warning 'This algorithm does not have a correct url and can therefore not be loaded', 'Warning'

    requestAlgorithm()

    $scope.goBack = ->
      $state.go 'algorithms'

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
