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

    $scope.dropzoneConfig =
      options:
        addRemoveLinks : true
        maxFilesize: 0.5
        dictDefaultMessage: '<span class="text-center"><span class="font-lg visible-xs-block visible-sm-block visible-lg-block"><span class="font-lg"><i class="fa fa-caret-right text-danger"></i> Drop files <span class="font-xs">to upload</span></span><span>&nbsp&nbsp<h4 class="display-inline"> (Or Click)</h4></span>'
        dictResponseError: 'Error uploading file!'
      eventHandlers:
        sending: (file, xhr, formData) ->
        success: (file, response) ->

    requestAlgorithm = ->
      algorithmsService.fetch().then (res) ->
        abstractAlgorithm = res.data.records[$stateParams.id]
        if abstractAlgorithm?.url?
          algorithmService.fetch(abstractAlgorithm.url).then (res) ->
            try
              $scope.algorithm = JSON.parse res.data
            catch e
              notificationService.add
                title: 'Error'
                content: 'Could not parse algorithm information'
                type: 'error'
                timeout: 5000
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
