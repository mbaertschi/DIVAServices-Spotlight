HomePage = require '../pages/home/page'

describe 'Home Page', ->
  page = null

  beforeAll ->
    browser.driver.manage().window().setSize(1280, 1440)
    page = new HomePage()
    page.visitPage()

  describe 'Layout', ->

    it 'has the breadcrumb Home / Home', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Home']

    it 'has the title Welcome > To the DIVAServices Spotlight project', ->
      expect(page.title).toEqual 'Welcome > To the DIVAServices Spotlight project'
