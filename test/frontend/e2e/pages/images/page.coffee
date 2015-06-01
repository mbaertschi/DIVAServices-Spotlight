PageObject     = require '../page_object'
path           = require 'path'

class ImagesPage extends PageObject

  constructor: (sub)->
    @url = "#/images/#{sub}"

  visitPage: ->
    # make sure the menu is expanded
    $("li[title='Images']").click()
    browser.sleep(500)
    super

  uploadTestImage: ->
    image = '../../../../test.png'
    absolutePath = path.resolve(__dirname, image)
    element.all(@by.css('input[type="file"]')).first().sendKeys(absolutePath)
    browser.sleep(1000)

  @has 'images', ->
    # hack fix. shouldn't matter anyways
    1

module.exports = ImagesPage
