angular.module('app.results').directive 'diaDatatable', [
  '$compile'

  ($compile) ->
    restrict: 'A'
    scope: tableOptions: '='
    link: (scope, element, attributes) ->

      options =
        sDom: '<\'dt-toolbar\'<\'col-xs-12 col-sm-6\'f><\'col-sm-6 col-xs-12 hidden-xs\'l>r>' + 't' + '<\'dt-toolbar-footer\'<\'col-sm-6 col-xs-12 hidden-xs\'i><\'col-xs-12 col-sm-6\'p>>'
        oLanguage:
          sSearch: '<span class=\'input-group-addon input-sm\'><i class=\'fa fa-search\'></i></span> '
          sLengthMenu: '_MENU_'
        autoWidth: false
        smartResponsiveHelper: null
        preDrawCallback: ->
          # Initialize the responsive datatables helper once.
          if !@smartResponsiveHelper
            @smartResponsiveHelper = new ResponsiveDatatablesHelper(element,
              tablet: 1024
              phone: 480)
        rowCallback: (nRow) ->
          @smartResponsiveHelper.createExpandIcon nRow
        drawCallback: (oSettings) ->
          @smartResponsiveHelper.respond()

      if attributes.tableOptions
        options = angular.extend(options, scope.tableOptions)

      _dataTable = undefined

      childFormat = element.find('.smart-datatable-child-format')

      if childFormat.length
        childFormatTemplate = childFormat.remove().html()
        element.on 'click', childFormat.data('childControl'), ->
          tr = $(this).closest('tr')
          row = _dataTable.row(tr)
          if row.child.isShown()
            # This row is already open - close it
            row.child.hide()
            tr.removeClass 'shown'
          else
            # Open this row
            childScope = scope.$new()
            childScope.d = row.data()
            html = $compile(childFormatTemplate)(childScope)
            scope.$apply -> row.child(html).show()
            tr.addClass 'shown'

      _dataTable = element.DataTable(options)
]
