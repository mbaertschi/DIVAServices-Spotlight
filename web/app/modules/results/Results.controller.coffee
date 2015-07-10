###
Controller ResultsPageController

* loads finished algorithms from diaProcessingQueue
* setups the diaDatatable directive
###
do ->
  'use strict'

  ResultsPageController = ($scope, $state, diaProcessingQueue) ->
    vm = @
    vm.results = diaProcessingQueue.getResults()

    vm.delete = (entry) ->
      angular.forEach vm.results, (result, index) ->
        if entry.algorithm.uuid is result.algorithm.uuid
          vm.results.splice index, 1
          $scope.safeApply ->
            $scope.$root.finished -= 1

    $scope.$watch 'vm.results', (newVal, oldVal) ->
      if newVal.length > oldVal.length
        $scope.safeApply -> $('#results-table').DataTable().row.add(newVal[newVal.length - 1]).draw()
    , true

    vm.tableOptions =
      data: vm.results
      columns: [
        {
          class: 'details-control'
          orderable: false
          data: null
          defaultContent: ''
        }
        {
          data: 'algorithm.name'
          render: (data, type, row) ->
            if type is 'display'
              '<span class="text-capitalize">' + data + '</span>'
            else
              data
        }
        { data: 'algorithm.description' }
        {
          data: 'input.image'
          render: (data, type, row) ->
            if type is 'display'
              '<div class="project-members"><img src=\"' + data.thumbUrl + '\"></div>'
            else
              data.thumbPath
        }
        { data: 'submit.start' }
        { data: 'submit.end' }
        { data: 'submit.duration' }
        {
          data: 'algorithm'
          width: '10%'
          render: (data, type, row) ->
            if type is 'display'
              """
              <div class="clearfix">
                <div class="btn-group inline">
                  <div class="btn btn-xs btn-primary action-button-back">Back</div>
                  <div class="btn btn-xs btn-danger action-button-delete">Delete</div>
                </div>
              </div>
              """
            else
              data
        }
      ]
      order: [[5, 'desc']]
      pageLength: 20
      lengthMenu: [ [10, 20, 50, -1], [10, 20, 50, 'All'] ]
      drawCallback: ->
        table = @
        table.on 'click', '.action-button-back', ->
          entry = table.api().row($(this).parents('tr')).data()
          $state.go 'algorithm', {id: entry.algorithm.id, backEntry: entry}
        table.on 'click', '.action-button-delete', ->
          entry = table.api().row($(this).parents('tr')).data()
          table.api().row($(this).parents('tr')).remove().draw()
          vm.delete entry

    vm

  angular.module('app.results')
    .controller 'ResultsPageController', ResultsPageController

  ResultsPageController.$inject = [
    '$scope'
    '$state'
    'diaProcessingQueue'
  ]
