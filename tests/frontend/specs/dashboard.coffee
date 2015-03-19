DashboardPage = require '../pages/dashboard/page'

describe 'Dashboard Page', ->
  page = null

  beforeAll ->
    page = new DashboardPage()
    page.visitPage()

  describe 'Layout', ->

    it 'has the breadcrumb Home / Dashboard', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Dashboard']

    it 'has the title Welcome> To the AI Revolution project', ->
      expect(page.title).toEqual 'Welcome> To the AI Revolution project'
