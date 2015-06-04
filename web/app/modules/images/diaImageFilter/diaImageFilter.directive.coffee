###
Directive diaImageFilter

* handles filters on filter page with camanJS
* updated images are stored on server
###
do ->
  'use strict'

  diaImageFilter = ->

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    restrict: 'AE'
    templateUrl: 'modules/images/diaImageFilter/diaImageFilter.view.html'
    link: link
    controller: 'DiaImageFilterController'

  angular.module('app.images')
    .directive 'diaImageFilter', diaImageFilter
