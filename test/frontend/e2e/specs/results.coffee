ResultsPage = require '../pages/results/page'

describe 'Results Page', ->
  page = null

  beforeAll ->
    page = new ResultsPage()
    page.visitPage()

  describe 'Layout', ->

    it 'has the breadcrumb Home / Results', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Results']

    it 'has the title Results > Check it out', ->
      expect(page.title).toEqual 'Results > Check it out'

  describe 'Results page', ->

    it 'should have exactly one result', ->
      # header and first result -> there are 2 entries
      expect(page.results.count()).toEqual 2

    it 'should display details by click on plus icon', ->
      expect(page.showDetails()).toBe true
