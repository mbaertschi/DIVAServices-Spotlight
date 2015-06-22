DocumentsPage = require '../pages/documents/page'

describe 'Document Page', ->

  describe 'FAQs page', ->
    page = null

    beforeEach ->
      page = new DocumentsPage 'faq'
      page.visitPage()

    it 'has the breadcrumb Home / Documentation / FAQ', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Documentation', 'FAQ']

    it 'has the title Documentation > For your information', ->
      expect(page.title).toEqual 'Documentation > For your information'

  describe 'API Backend page', ->
    page = null

    beforeEach ->
      page = new DocumentsPage 'api/backend'
      page.visitPage('API')

    it 'has the breadcrumb Home / Documentation / API / Backend', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Documentation', 'API', 'Backend']

  describe 'API Server page', ->
    page = null

    beforeEach ->
      page = new DocumentsPage 'api/server'
      page.visitPage('API')

    it 'has the breadcrumb Home / Documentation / API / Server', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Documentation', 'API', 'Server']
