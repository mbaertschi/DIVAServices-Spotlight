angular.module('app.algorithms').controller 'AlgorithmsPageController', [
  '$scope'
  'notificationService'
  'algorithmService'
  'mySocket'
  '_'

  ($scope, notificationService, algorithmService, mySocket, _) ->
    $scope.algorithms = {}

    $scope.$on 'socket:update structure', (ev, data) ->
      data = JSON.parse(data)
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
      algorithmService.fetch().then (res) ->
        $scope.algorithms = res.data
      , (err) ->
        notificationService.add
          title: 'Request failed'
          content: err.data
          type: 'danger'
          timeout: 5000

    retrieveLinks()
]
