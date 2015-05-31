ImagesPage = require '../pages/images/page'

describe 'Images Page', ->

  describe 'Upload page', ->
    page = null

    beforeEach ->
      page = new ImagesPage 'upload'
      page.visitPage()

    it 'has the breadcrumb Home / Images / Upload', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Images', 'Upload']

    it 'has the title My Images > Manage your images here', ->
      expect(page.title).toEqual 'My Images > Manage your images here'

    describe 'Dropzone upload', ->

      beforeEach ->
        page.uploadTestImage()

      it 'should have an uploaded image', ->
        expect(page.images).toEqual 1


  describe 'Gallery page', ->
    page = null

    beforeEach ->
      page = new ImagesPage 'gallery'
      page.visitPage()

    it 'has the breadcrumb Home / Images / Gallery', ->
      expect(page.breadcrumbs).toEqual ['Home', 'Images', 'Gallery']

    it 'has the title My Images > Manage your images here', ->
      expect(page.title).toEqual 'My Images > Manage your images here'
