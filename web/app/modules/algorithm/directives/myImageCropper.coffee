angular.module('app.algorithm').directive 'diaImageCropper', [
  'toastr'
  'diaStateManager'

  (toastr, diaStateManager) ->
    restrict: 'A'
    templateUrl: 'modules/algorithm/directives/imageCropper.html'
    scope: true

    link: (scope, element, attrs) ->

]
