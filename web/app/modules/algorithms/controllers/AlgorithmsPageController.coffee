angular.module('app.algorithms').controller 'AlgorithmsPageController', [
  '$scope'
  'notificationService'
  'algorithmService'

  ($scope, notificationService, algorithmService, Pusher, $http) ->
    $scope.algorithms = {}

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
