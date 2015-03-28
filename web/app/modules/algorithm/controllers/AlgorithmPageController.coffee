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

      # we need to store the abstract representation of this algorithm
      algorithmsService.fetch().then (res) ->
        algorithms = res.data.records
        angular.forEach algorithms, (alg) ->
          if alg.url is url
            abstractAlgorithm = alg

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
