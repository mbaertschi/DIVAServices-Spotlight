###
Directive diaImageFilter

* handles filters on filter page with camanJS
* updated images are stored on server
###
do ->
  'use strict'

  diaImageFilter = ->

    directive = ->
      restrict: 'AE'
      templateUrl: 'modules/images/diaImageFilter/diaImageFilter.view.html'
      link: link
      controller: 'DiaImageFilterController'

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    directive()

  angular.module('app.images')
    .directive 'diaImageFilter', diaImageFilter
