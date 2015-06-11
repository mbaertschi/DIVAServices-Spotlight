###
Directive diaDatatable

* loads and setups the datatable used for displaying algorithm results
###
do ->
  'use strict'

  diaDatatable = ->

    directive = ->
      restrict: 'A'
      scope:
        tableOptions: '='
        clickDelete: '&'
      link: link
      controller: 'DiaDatatableController'
      controllerAs: 'vm'
      bindToController: true

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    directive()

  angular.module('app.widgets')
    .directive 'diaDatatable', diaDatatable
