DocumentsPage = require '../pages/documents/page'

describe 'Document Page', ->
  page = null

  beforeAll ->
    page = new DocumentsPage()
    page.visitPage()

  describe 'Layout', ->

    it 'Documents page has the breadcrumb Home / Documents', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Documents']

    it 'Documents page has the title Documents> For your information', ->
      expect(page.title).toEqual 'Documents> For your information'
