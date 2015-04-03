angular.module('app.algorithms').controller 'AlgorithmsPageController', [
  '$scope'
  'notificationService'
  'algorithmsService'
  'mySocket'
  '$state'
  'mySettings'

  ($scope, notificationService, algorithmsService, mySocket, $state, mySettings) ->
    $scope.algorithms = []

    retrieveLinks = ->
      algorithmsService.fetch().then (res) ->
        $scope.algorithms = res.data
      , (err) ->
        notificationService.add
          title: 'Request failed'
          content: err.data
          type: 'danger'
          timeout: 5000

    retrieveLinks()

    $scope.thisAlgorithm = (algorithm) ->
      url = new URL algorithm.url
      host = url.host
      algorithm = url.pathname
      if algorithm
        algorithm = algorithm.substring(1)
      $state.go 'algorithm', {host: host, algorithm: algorithm}

    mySettings.fetch('socket').then (socket) ->
      if socket.run?
        $scope.$on 'socket:update algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            available = false
            angular.forEach $scope.algorithms, (scopeAlgorithm, index) ->
              if algorithm.url is scopeAlgorithm.url
                $scope.algorithms[index] = algorithm
          notificationService.add
            title: 'Updated'
            content: 'Algorithms have changed'
            type: 'info'
            timeout: 5000

        $scope.$on 'socket:add algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            $scope.algorithms.push algorithm
          notificationService.add
            title: 'Added'
            content: 'Added new algorithms'
            type: 'info'
            timeout: 5000

        $scope.$on 'socket:delete algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            angular.forEach $scope.algorithms, (scopeAlgorithm, index) ->
              if algorithm.url is scopeAlgorithm.url
                $scope.algorithms.splice index, 1
          notificationService.add
            title: 'Delete'
            content: 'Deleted one or more algorithms'
            type: 'info'
            timeout: 5000

        $scope.$on 'socket:error', (ev, data) ->
          notificationService.add
            title: 'Error'
            content: 'There was an error while fetching algorithms'
            type: 'error'
            timeout: 5000
]
