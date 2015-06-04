###
Directive diaImageCropper

* handles image croppy and rotating
* sends updated images to server
###
do ->
  'use strict'

  diaImageCropper = ->

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    restrict: 'AE'
    templateUrl: 'modules/images/diaImageCropper/diaImageCropper.view.html'
    link: link
    controller: 'DiaImageCropperController'
    controllerAs: 'vm'
    bindToController: true

  angular.module('app.images')
    .directive 'diaImageCropper', diaImageCropper
