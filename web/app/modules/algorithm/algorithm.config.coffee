do ->
  'use strict'

  algorithm = angular.module 'app.algorithm'

  stateProvider = ($stateProvider) ->
    $stateProvider.state 'algorithm',
      parent: 'main'
      url: '/algorithm/:id'
      templateUrl: '/modules/algorithm/algorithm.view.html'
      controller: 'AlgorithmPageController'
      controllerAs: 'vm'
      params:
        backEntry: null
      data:
        title: 'Algorithm'
      resolve:
        socketPrepService: socketPrepService
        algorithmsPrepService: algorithmsPrepService
        imagesPrepService: imagesPrepService

  socketPrepService = (diaSettings) ->
    diaSettings.fetch('socket')

  algorithmsPrepService = ($stateParams, diaAlgorithmsService) ->
    diaAlgorithmsService.fetchAlgorithm $stateParams.id

  imagesPrepService = (diaImagesService) ->
    diaImagesService.fetch().then (res) ->
      images: res.data

  algorithm.config stateProvider
