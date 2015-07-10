PageObject     = require '../page_object'

class ResultsPage extends PageObject

  url: '#/results'

  @has 'results', ->
    element(@by.css('#results-table')).all(@by.css('.details-control'))

  showDetails: ->
    element(@by.css('#results-table')).all(@by.css('.details-control')).get(1).click()
    browser.sleep(500)
    element(@by.css('.table-inputs')).isPresent()


module.exports = ResultsPage
