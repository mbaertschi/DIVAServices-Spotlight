###
Directive diaAlgorithmImagesGallery

* displays all images for current session in a small gallery
* handles selectedImage
###
angular.module('app.algorithm').directive 'diaAlgorithmImagesGallery', [

  ->
    restrict: 'E'
    templateUrl: 'modules/algorithm/directives/diaAlgorithmImagesGallery/template.html'

    link: (scope, element, attrs) ->

      # set selectedImage variable in parent scope to this image
      scope.selectImage = (index) ->
        scope.setSelectedImage scope.images[index]
]
