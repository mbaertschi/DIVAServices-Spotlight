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

  describe 'Algorithms page', ->

    beforeEach ->
      page = new AlgorithmsPage()
      page.visitPage()

    it 'shows all five dummy algorithms from the dummy backend', ->
      expect(page.algorithms.count()).toEqual 5

    describe 'Multiscaleipd', ->

      it 'should display all inputs', ->
        expect(page.showMultiscale().inputs.count()).toEqual 8

    describe 'Otsubinazrization', ->

      it 'should be processed successfully', ->
        expect(page.submitOtsubinazrization().success).toBe true
