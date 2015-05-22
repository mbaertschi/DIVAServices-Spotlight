angular.module('app.algorithms').controller 'AlgorithmsPageController', [
  '$scope'
  'toastr'
  'algorithmsService'
  'mySocket'
  '$state'
  'mySettings'

  ($scope, toastr, algorithmsService, mySocket, $state, mySettings) ->
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
      $state.go 'algorithm', {id: algorithm._id}

    mySettings.fetch('socket').then (socket) ->
      if socket.run?
        $scope.$on 'socket:update algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            available = false
            angular.forEach $scope.algorithms, (scopeAlgorithm, index) ->
              if algorithm.url is scopeAlgorithm.url
                $scope.algorithms[index] = algorithm
          toastr.info 'Algorithms have changed', 'Updated'

        $scope.$on 'socket:add algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            $scope.algorithms.push algorithm
          toastr.info 'Added new algorithms', 'Added'

        $scope.$on 'socket:delete algorithms', (ev, algorithms) ->
          angular.forEach algorithms, (algorithm) ->
            angular.forEach $scope.algorithms, (scopeAlgorithm, index) ->
              if algorithm.url is scopeAlgorithm.url
                $scope.algorithms.splice index, 1
          toastr.info 'Deleted one or more algorithms', 'Delete'

        $scope.$on 'socket:error', (ev, data) ->
          toastr.error 'There was an error while fetching algorithms', 'Error'
]
