DashboardPage = require '../pages/dashboard/page'

describe 'Dashboard Page', ->
  page = null

  beforeAll ->
    browser.driver.manage().window().setSize(1280, 1440)
    page = new DashboardPage()
    page.visitPage()

  describe 'Layout', ->

    it 'has the breadcrumb Home / Dashboard', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Dashboard']

    it 'has the title Welcome > To the DIA-Distributed project', ->
      expect(page.title).toEqual 'Welcome > To the DIA-Distributed project'
