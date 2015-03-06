angular.module('app').controller 'DashboardPageController', [
  'alertService'
  'notificationService'

  (alertService, notificationService) ->

    notificationService.add
      title: 'Test'
      description: 'Test description'
      type: 'danger'
      timeout: 3000

    alertService.add 'info', 'test info', 3
]
