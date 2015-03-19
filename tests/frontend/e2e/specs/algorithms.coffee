AlgorithmsPage = require '../pages/algorithms/page'

describe 'Algorithms Page', ->
  page = null

  beforeAll ->
    page = new AlgorithmsPage()
    page.visitPage()

  describe 'Layout', ->

    it 'Algorithms page has the breadcrumb Home / Algorithms', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Algorithms']

    it 'Algorithms page has the title Algorithms> Get your work done', ->
      expect(page.title).toEqual 'Algorithms> Get your work done'

  describe 'Algorithms', ->

    it 'Algorithms page shows all four dummy algorithms from the dummy backend', ->
      expect(page.algorithms.count()).toEqual 4
