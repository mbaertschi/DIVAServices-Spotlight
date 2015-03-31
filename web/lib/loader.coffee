request     = require 'request'
async       = require 'async'
logger      = require './logger'
_           = require 'lodash'

loader = exports = module.exports = {}

loader.get = (settings, callback) ->
  return callback 'please specify options in your settings' if not settings?.options?

  settings.options.timeout ||= 8000
  settings.options.headers ||= {}
  settings.retries ||= 7
  settings.counter = 0

  async.retry settings.retries, ((next) ->
    settings.counter++
    _load settings, next
  ), (err, result) ->
    logger.log 'debug', "#{settings.retries} attempts failed with err: #{err}", 'Loader' if err?
    callback err, result


_load = (settings, callback) ->
  options = _.clone settings.options

  logger.log 'debug', "[#{settings.counter}] load uri=#{options.uri}", 'Loader'

  request options, (err, res, body) ->
    return callback err if err?

    if res.statusCode isnt 200
      return callback "response state #{res.statusCode}"

    callback null, body
