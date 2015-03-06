angular.module('app').factory 'alertService', [
  '$rootScope'
  '$interval'

  ($rootScope, $interval) ->

    $rootScope.alerts = []
    alertService =

      add: (type, msg, timeout) ->
        unless type in ['success', 'info', 'warning', 'danger']
          type = 'info'

        $rootScope.alerts.push
          type: type
          msg: msg
          close: -> alertService.closeAlert @

        if timeout? and timeout isnt 0
          timeout *= 1000
          $interval (->
            alertService.closeAlert 0
            return
          ), timeout, 1

      closeAlert: (alert) ->
        @_closeAlertIdx $rootScope.alerts.indexOf(alert)

      _closeAlertIdx: (index) ->
        $rootScope.alerts.splice index, 1
]
