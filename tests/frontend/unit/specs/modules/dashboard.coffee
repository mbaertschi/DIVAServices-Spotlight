'use strict'

describe 'app.dashboard module', ->

  # Mocks
  mockAlertService        = undefined
  mockNotificationService = undefined

  # Variables
  dashboardController     = undefined
  scope                   = undefined

  # Load the dashboard module
  beforeEach module 'app.dashboard', ($provide) ->
    # Define and provide mock services
    mockAlertService = {}
    $provide.value 'alertService', mockAlertService

    mockNotificationService = {}
    $provide.value 'notificationService', mockNotificationService

    null

  # Inject the dashboard dependencies
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    dashboardController = $controller('DashboardPageController', $scope:scope)

  describe 'dashboard controller', ->
    # Controller tests
    it 'should be defined', ->
      expect(dashboardController).toBeDefined()
