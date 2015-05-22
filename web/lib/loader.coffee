request     = require 'request'
async       = require 'async'
logger      = require './logger'
nconf       = require 'nconf'
_           = require 'lodash'

loader = exports = module.exports = {}

loader.get = (settings, callback) ->
  return callback 'please specify options in your settings' if not settings?.options?

  settings.options.timeout ||= nconf.get 'server:timeout'
  settings.options.headers ||= {}
  settings.retries ||= nconf.get 'loader: retries'
  settings.counter = 0

  async.retry settings.retries, ((next) ->
    settings.counter++
    _load settings, next
  ), (err, result) ->
    logger.log 'debug', "#{settings.retries} attempts failed with error=#{err}", 'Loader' if err?
    callback err, result

loader.post = (settings, body, callback) ->
  return callback 'please specify options in your settings' if not settings?.options?
  return callback 'please pass a json object as second parameter' if not _.isObject(body)?

  settings.options.timeout ||= nconf.get 'server:timeout'
  settings.options.headers ||= {}
  settings.options.method = 'POST'
  settings.options.json = true
  settings.options.body = body
  settings.retries = 1
  settings.counter = 0

  _load settings, (err, result) ->
    logger.log 'info', "post failed with error=#{err}", 'Loader' if err?
    callback err, result

_load = (settings, callback) ->
  options = _.clone settings.options

  logger.log 'debug', "[#{settings.counter}] load uri=#{options.uri}", 'Loader'

  request options, (err, res, body) ->
    return callback err if err?

    if res.statusCode isnt 200
      return callback res.statusCode

    callback null, body
