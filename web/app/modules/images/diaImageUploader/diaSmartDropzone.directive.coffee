###
Directive diaSmartDropzone

* handles functionality for uploading images with Dropzone.js
* loads stored images from server (for active session) on page reload
* loads Dropzone settings from server
###
do ->
  'use strict'

  diaSmartDropzone = ->

    directive = ->
      restrict: 'AE'
      link: link
      controller: 'DiaSmartDropzoneController'
      controllerAs: 'vm'
      bindToController: true

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    directive()

  angular.module('app.images')
    .directive 'diaSmartDropzone', diaSmartDropzone
