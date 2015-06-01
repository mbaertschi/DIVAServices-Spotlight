DocumentsPage = require '../pages/documents/page'

describe 'Document Page', ->

  describe 'HowTo page', ->
    page = null

    beforeEach ->
      page = new DocumentsPage 'howto'
      page.visitPage()

    it 'has the breadcrumb Home / Documents / FAQ', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Documents', 'HowTo']

    it 'has the title Documents > For your information', ->
      expect(page.title).toEqual 'Documents > For your information'

  describe 'FAQs page', ->
    page = null

    beforeEach ->
      page = new DocumentsPage 'faq'
      page.visitPage()

    it 'has the breadcrumb Home / Documents / FAQ', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Documents', 'FAQ']

    it 'has the title Documents > For your information', ->
      expect(page.title).toEqual 'Documents > For your information'

  describe 'API Backend page', ->
    page = null

    beforeEach ->
      page = new DocumentsPage 'api/backend'
      page.visitPage('API')

    it 'has the breadcrumb Home / Documents / API Documentation / Backend', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Documents', 'API Documentation', 'Backend']

  describe 'API Server page', ->
    page = null

    beforeEach ->
      page = new DocumentsPage 'api/server'
      page.visitPage('API')

    it 'has the breadcrumb Home / Documents / API Documentation / Server', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Documents', 'API Documentation', 'Server']
