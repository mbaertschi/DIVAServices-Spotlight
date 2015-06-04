PageObject     = require '../page_object'
AlgorithmView = require './algorithm_view'

class AlgorithmsPage extends PageObject

  url: '#/algorithms'

  @has 'algorithms', ->
    element.all @by.repeater('algorithm in vm.algorithms')

  showMultiscale: ->
    element(@by.css('.algorithms-overview[heading="multiscaleipd"]')).element(@by.css('[ng-click="goTo()"]')).click()
    browser.sleep(500)
    new AlgorithmView element

  submitOtsubinazrization: ->
    element(@by.css('.algorithms-overview[heading="otsubinazrization"]')).element(@by.css('[ng-click="goTo()"]')).click()
    browser.sleep(500)
    new AlgorithmView element

module.exports = AlgorithmsPage
