DocumentsPage = require '../pages/documents/page'

describe 'Document Page', ->
  page = null

  beforeAll ->
    page = new DocumentsPage()
    page.visitPage()

  describe 'Layout', ->

    it 'has the breadcrumb Home / Documents', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Documents']

    it 'has the title Documents> For your information', ->
      expect(page.title).toEqual 'Documents> For your information'
