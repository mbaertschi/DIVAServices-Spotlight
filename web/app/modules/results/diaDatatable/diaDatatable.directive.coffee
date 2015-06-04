###
Directive diaDatatable

* loads and setups the datatable used for displaying algorithm results
###
do ->
  'use strict'

  diaDatatable = ->

    link = (scope, element, attrs, ctrl) ->
      ctrl.init element

    restrict: 'A'
    scope: tableOptions: '='
    link: link
    controller: 'DiaDatatableController'
    controllerAs: 'vm'
    bindToController: true

  angular.module('app.results')
    .directive 'diaDatatable', diaDatatable
