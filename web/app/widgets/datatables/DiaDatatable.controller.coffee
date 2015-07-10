###
Controller diaDatatable

* loads and setups the datatable used for displaying algorithm results
###
do ->
  'use strict'

  DiaDatatableController = ($scope, $compile) ->
    vm = @
    vm.element = null
    vm.dataTable = undefined
    vm.options = null

    @init = (element) ->
      vm.element = element
      setup()
      render()

    setup = ->
      vm.options =
        sDom: '<\'dt-toolbar\'<\'col-xs-12 col-sm-6\'f><\'col-sm-6 col-xs-12 hidden-xs\'l>r>' + 't' + '<\'dt-toolbar-footer\'<\'col-sm-6 col-xs-12 hidden-xs\'i><\'col-xs-12 col-sm-6\'p>>'
        oLanguage:
          sSearch: '<span class=\'input-group-addon input-sm\'><i class=\'fa fa-search\'></i></span> '
          sLengthMenu: '_MENU_'
        autoWidth: false

      if vm.tableOptions
        vm.options = angular.extend(vm.options, vm.tableOptions)

    render = ->
      childFormat = vm.element.find('.smart-datatable-child-format')
      if childFormat.length
        childFormatTemplate = childFormat.remove().html()
        vm.element.on 'click', childFormat.data('childControl'), ->
          tr = $(this).closest('tr')
          row = vm.dataTable.row(tr)
          if row.child.isShown()
            # This row is already open - close it
            row.child.hide()
            tr.removeClass 'shown'
          else
            # Open this row
            childScope = $scope.$new()
            childScope.d = row.data()
            html = $compile(childFormatTemplate)(childScope)
            $scope.$apply -> row.child(html).show()
            tr.addClass 'shown'

      vm.dataTable = vm.element.DataTable(vm.options)

  angular.module('app.widgets')
    .controller 'DiaDatatableController', DiaDatatableController

  DiaDatatableController.$inject = [
    '$scope'
    '$compile'
  ]
