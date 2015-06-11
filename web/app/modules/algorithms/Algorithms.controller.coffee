###
Controller AlgorithmsPageController

* displays information about all available algorithms
* handles socket.io messages if any algorithms have changed
###
do ->
  'use strict'

  AlgorithmsPageController = ($scope, $state, socketPrepService, algorithmsPrepService, diaSocket, toastr) ->
    vm = @
    vm.algorithms = algorithmsPrepService.algorithms

    vm.tableOptions =
      data: vm.algorithms
      iDisplayLength: 15,
      columns: [
        {
          data: 'name'
          render: (data, type, row) ->
            if type is 'display'
              '<span class="text-capitalize">' + data + '</span>'
            else
              data
        }
        { data: 'host' }
        { data: 'description' }
        {
          data: '_lastChange'
          render: (data, type, row) ->
            moment(data).format 'DD.MM.YY HH:mm:ss'
        }
        {
          data: '_id'
          width: '1%'
          render: (data, type, row) ->
            if type is 'display'
              '<button class="btn btn-xs btn-primary hvr-grow-shadow action-button-apply">Apply <i class="fa fa-arrow-right"</button>'
            else
              data
        }
      ]
      order: [[3, 'desc']]

    if socketPrepService.settings.run
      $scope.$on 'socket:update algorithms', (ev, algorithms) ->
        table = $('#algorithm-table').DataTable()
        angular.forEach algorithms, (algorithm) ->
          angular.forEach vm.algorithms, (scopeAlgorithm, index) ->
            if algorithm._id is scopeAlgorithm._id
              vm.algorithms[index] = algorithm
              table.rows (idx, data) ->
                if data._id is algorithm._id
                  table.row(idx).data(algorithm).draw()
        toastr.info 'Algorithms have changed', 'Updated'

      $scope.$on 'socket:add algorithms', (ev, algorithms) ->
        table = $('#algorithm-table').DataTable()
        angular.forEach algorithms, (algorithm) ->
          vm.algorithms.push algorithm
          table.row.add(algorithm).draw()
        toastr.info 'Added new algorithms', 'Added'

      $scope.$on 'socket:delete algorithms', (ev, algorithms) ->
        table = $('#algorithm-table').DataTable()
        angular.forEach algorithms, (algorithm) ->
          angular.forEach vm.algorithms, (scopeAlgorithm, index) ->
            if algorithm._id is scopeAlgorithm._id
              vm.algorithms.splice index, 1
              table.rows((idx, data) ->
                data._id is algorithm._id
              ).remove().draw()
        toastr.info 'Deleted one or more algorithms', 'Delete'

      $scope.$on 'socket:error', (ev, data) ->
        toastr.error 'There was an error while fetching algorithms', 'Error'
    vm

  angular.module('app.algorithms')
    .controller 'AlgorithmsPageController', AlgorithmsPageController

  AlgorithmsPageController.$inject = [
    '$scope'
    '$state'
    'socketPrepService'
    'algorithmsPrepService'
    'diaSocket'
    'toastr'
  ]
