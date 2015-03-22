'use strict'

describe 'app.docs module', ->

  # Variables
  docsController          = undefined
  scope                   = undefined

  # Load the dashboard module
  beforeEach module 'app.docs'

  # Inject the dashboard dependencies
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    docsController = $controller('DocsPageController', $scope:scope)

  describe 'documents controller', ->
    # Controller tests
    it 'should be defined', ->
      expect(docsController).toBeDefined()
