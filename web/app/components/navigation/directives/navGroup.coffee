angular.module('app').directive 'navGroup', [ ->
  restrict: 'AE'
  controller: 'NavGroupController'
  transclude: true
  replace: true
  link: (scope, element, attrs) ->
    $(element[0]).jarvismenu
      accordion: true
      speed: 350
      closedSign: '<em class="fa fa-plus-square-o"></em>'
      openedSign: '<em class="fa fa-minus-square-o"></em>'
    scope.getElement = -> element

  template: '<nav><ul ng-transclude></ul></nav>'
]
