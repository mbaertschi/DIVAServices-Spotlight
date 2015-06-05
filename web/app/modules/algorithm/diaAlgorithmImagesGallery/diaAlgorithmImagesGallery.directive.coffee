###
Directive diaAlgorithmImagesGallery

* displays all images for current session in a small gallery
* handles selectedImage
###
do ->
  'use strict'

  diaAlgorithmImagesGallery = ->

    directive = ->
      restrict: 'AE'
      templateUrl: 'modules/algorithm/diaAlgorithmImagesGallery/diaAlgorithmImagesGallery.view.html'
      scope:
        images: '='
        setSelectedImage: '&'
      link: link

    link = (scope, element, attrs) ->
      # set selectedImage variable in parent scope to this image
      scope.selectImage = (index) ->
        scope.setSelectedImage(image: scope.images[index])

    directive()

  angular.module('app.algorithm')
    .directive 'diaAlgorithmImagesGallery', diaAlgorithmImagesGallery
