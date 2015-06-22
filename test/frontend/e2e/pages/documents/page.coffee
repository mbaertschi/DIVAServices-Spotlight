PageObject     = require '../page_object'

class DocumentsPage extends PageObject

  constructor: (doc)->
    @url = "#/docs/#{doc}"

  visitPage: (sub) ->
    # make sure the menu is expanded
    $("li[title='Documentation']").click()
    browser.sleep(500)
    # make sure the sub menu is expanded
    if sub?
      $("li[title='#{sub}']").click()
      browser.sleep(500)
    super

module.exports = DocumentsPage
