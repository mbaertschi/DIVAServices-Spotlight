angular.module('app.algorithm').controller 'AlgorithmPageController', [
  '$scope'
  '$stateParams'
  'algorithmService'
  'algorithmsService'
  'notificationService'

  ($scope, $stateParams, algorithmService, algorithmsService, notificationService) ->
    $scope.algorithm = {}

    requestAlgorithm = ->
      algorithmsService.fetch().then (res) ->
        $scope.algorithm = res.data.records[$stateParams.id]
        # algorithmService.fetch($scope.algorithm.url).then (res) ->
        #   console.log res
        # , (err) ->
        #   console.log err
      , (err) ->
        notificationService.add
          title: 'Error'
          content: 'Could no fetch algorithm'
          type: 'error'
          timeout: 5000

    requestAlgorithm()

]
