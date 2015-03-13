angular.module('app.algorithm').controller 'AlgorithmPageController', [
  '$scope'
  '$stateParams'
  'algorithmService'
  'algorithmsService'
  'notificationService'
  'mySocket'
  '$state'
  '$timeout'
  '_'

  ($scope, $stateParams, algorithmService, algorithmsService, notificationService, mySocket, $state, $timeout, _) ->
    $scope.algorithm = null
    abstractAlgorithm = null

    requestAlgorithm = ->
      algorithmsService.fetch().then (res) ->
        abstractAlgorithm = res.data.records[$stateParams.id]
        if abstractAlgorithm?.url?
          algorithmService.fetch(abstractAlgorithm.url).then (res) ->
            $scope.algorithm = JSON.parse res.data
          , (err) ->
            notificationService.add
              title: 'Error'
              content: 'Could not load algorithm'
              type: 'error'
              timeout: 5000
        else
          notificationService.add
            title: 'Warning'
            content: 'This algorithm does not have an url and can therefore not be loaded'
            type: 'warning'
            timeout: 5000
      , (err) ->
        notificationService.add
          title: 'Error'
          content: 'Could no fetch algorithm'
          type: 'error'
          timeout: 5000

    requestAlgorithm()

    $scope.goBack = ->
      $state.go 'algorithms'

    $scope.$on 'socket:update structure', (ev, data) ->
      available = false
      _.each data, (alg) ->
        if _.isEqual alg, abstractAlgorithm
          available = true
      if not available
        notificationService.add
          title: 'Warning'
          content: 'This algorithm has been removed. Going back to algorithms page in 5 seconds'
          type: 'warning'
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
