angular.module('app.algorithm').directive 'diaImageCropper', [
  'toastr'
  'diaStateManager'

  (toastr, diaStateManager) ->
    restrict: 'AC'
    templateUrl: 'modules/algorithm/directives/imageCropper.html'

    link: (scope, element, attrs) ->
      scope.rotationAngle = 45
]
