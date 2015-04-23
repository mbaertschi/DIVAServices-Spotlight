util = require('util')

IGNORED_LOGS = [
  # add console outputs you want to ignore
  /http:\/\/localhost:3000\/ 0:0 Failed to load resource: net::ERR_EMPTY_RESPONSE/
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
