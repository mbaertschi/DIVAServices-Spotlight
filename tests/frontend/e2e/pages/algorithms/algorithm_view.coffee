PageObject = require('../page_object')

class AlgorithmView extends PageObject

  constructor: (@element) ->
    @element(@by.css('[ng-click="selectImage($index)"]')).click()
    browser.sleep(500)

  @has 'inputs', ->
    @element.all @by.repeater('entry in inputs')

  @has 'success', ->
    @element(@by.css('.panel[heading="Apply Algorithm on Image"]')).element(@by.css('[ng-click="submit()"]')).click()
    browser.sleep(3000)
    @element(@by.css('.toast-info')).isPresent()

module.exports = AlgorithmView
