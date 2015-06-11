PageObject     = require '../page_object'
AlgorithmView = require './algorithm_view'

class AlgorithmsPage extends PageObject

  url: '#/algorithms'

  @has 'algorithms', ->
    element.all @by.css('#algorithm-table tbody tr')

  showMultiscale: ->
    element(@by.cssContainingText('#algorithm-table tbody td span', 'multiscaleipd')).element(@by.xpath('../..')).element(@by.css('.action-button-apply')).click()
    browser.sleep(500)
    new AlgorithmView element

  submitOtsubinazrization: ->
    element(@by.cssContainingText('#algorithm-table tbody td span', 'sauvalabinarization')).element(@by.xpath('../..')).element(@by.css('.action-button-apply')).click()
    browser.sleep(500)
    new AlgorithmView element

module.exports = AlgorithmsPage
