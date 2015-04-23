AlgorithmsPage = require '../pages/algorithms/page'

describe 'Algorithms Page', ->
  page = null

  beforeAll ->
    page = new AlgorithmsPage()
    page.visitPage()

  describe 'Layout', ->

    it 'has the breadcrumb Home / Algorithms', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Algorithms']

    it 'has the title Algorithms > Get your work done', ->
      expect(page.title).toEqual 'Algorithms > Get your work done'

  describe 'Algorithms', ->

    it 'shows all four dummy algorithms from the dummy backend', ->
      expect(page.algorithms.count()).toEqual 4
