angular.module('app.algorithm').controller 'AlgorithmPageController', [
  '$scope'
  '$stateParams'
  'algorithmService'
  'notificationService'
  'mySocket'
  '$state'
  '$timeout'

  ($scope, $stateParams, algorithmService, notificationService, mySocket, $state, $timeout) ->
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
            notificationService.add
              title: 'Error'
              content: 'Could not parse algorithm information'
              type: 'danger'
              timeout: 5000
        , (err) ->
          notificationService.add
            title: 'Error'
            content: 'Could not load algorithm'
            type: 'danger'
            timeout: 5000
      else
        notificationService.add
          title: 'Warning'
          content: 'This algorithm does not have a correct url and can therefore not be loaded'
          type: 'warning'
          timeout: 5000

    requestAlgorithm()

    $scope.goBack = ->
      $state.go 'algorithms'

    $scope.$on 'socket:update algorithms', (ev, algorithms) ->
      angular.forEach algorithms, (algorithm) ->
        if $scope.algorithm?.url is algorithm.url
          notificationService.add
            title: 'Warning'
            content: 'This algorithm has been updated. Going back to algorithms page in 5 seconds'
            type: 'warning'
            timeout: 5000
          $timeout (-> $state.go 'algorithms'), 5000

    $scope.$on 'socket:delete algorithms', (ev, algorithms) ->
      angular.forEach algorithms, (algorithm) ->
        if algorithm.url is $scope.algorithm.url
          notificationService.add
            title: 'Sorry'
            content: 'This algorithm has been removed. Going back to algorithms page in 5 seconds'
            type: 'danger'
            timeout: 5000
          $timeout (-> $state.go 'algorithms'), 5000
          
    $scope.$on 'socket:error', (ev, data) ->
      notificationService.add
        title: 'Error'
        content: 'There was an error while fetching algorithms'
        type: 'error'
        timeout: 5000
      $state.go 'dashboard'

]
