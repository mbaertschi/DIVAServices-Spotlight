PageObject     = require '../page_object'

class AlgorithmsPage extends PageObject

  url: '#/algorithms'

  @has 'algorithms', ->
    element.all @by.repeater('algorithm in algorithms.records')

module.exports = AlgorithmsPage
