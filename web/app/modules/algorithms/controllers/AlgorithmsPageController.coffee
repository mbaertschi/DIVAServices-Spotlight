angular.module('app.algorithms').controller 'AlgorithmsPageController', [
  '$scope'
  '$state'
  'diaSocket'
  'diaSettings'
  'diaAlgorithmsService'
  'toastr'

  ($scope, $state, diaSocket, diaSettings, diaAlgorithmsService, toastr) ->
    $scope.algorithms = []

    retrieveLinks = ->
      diaAlgorithmsService.fetch().then (res) ->
        $scope.algorithms = res.data
      , (err) -> toastr.error err.statusText, 'Request failed'

    retrieveLinks()

    $scope.thisAlgorithm = (algorithm) ->
      $state.go 'algorithm', {id: algorithm._id}

    diaSettings.fetch('socket').then (socket) ->
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
