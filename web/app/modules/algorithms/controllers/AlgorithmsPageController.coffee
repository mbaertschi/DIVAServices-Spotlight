angular.module('app.algorithms').controller 'AlgorithmsPageController', [
  '$scope'
  'notificationService'
  'algorithmsService'
  'mySocket'
  '_'
  '$state'

  ($scope, notificationService, algorithmsService, mySocket, _, $state) ->
    $scope.algorithms = {}

    $scope.$on 'socket:update structure', (ev, data) ->
      if not _.isEqual(data, $scope.algorithms)
        notificationService.add
          title: 'Updated'
          content: 'Algorithms have changed'
          type: 'info'
          timeout: 5000
        $scope.algorithms = data

    $scope.$on 'socket:error', (ev, data) ->
      notificationService.add
        title: 'Error'
        content: 'There was an error while fetching algorithms'
        type: 'error'
        timeout: 5000

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
]
