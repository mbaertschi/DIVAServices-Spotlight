angular.module('app.algorithm').directive 'diaAlgorithmImagesGallery', [

  ->
    restrict: 'E'
    templateUrl: 'modules/algorithm/directives/diaAlgorithmImagesGallery/template.html'

    link: (scope, element, attrs) ->

      scope.selectImage = (index) ->
        scope.setSelectedImage scope.images[index]
]
