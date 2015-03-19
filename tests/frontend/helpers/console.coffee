util = require('util')

IGNORED_LOGS = [
  # add console outputs you want to ignore
]

isIgnored = (log)->
  IGNORED_LOGS.some (pattern)-> pattern.test log.message

filterLogs = (logs)->
  logs.filter (log)-> not isIgnored log

consoleHelper =

  expectEmptyConsole: ->
    browser.manage().logs().get('browser').then (logs)->
      filterLogs(logs).forEach (log)->
        expect(log.message).toEqual ''


module.exports = consoleHelper
