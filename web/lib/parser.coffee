logger      = require './logger'
nconf       = require 'nconf'
async       = require 'async'
_           = require 'lodash'
loader      = require './loader'

parser = exports = module.exports = {}

parser.parseRoot = (structure, callback) ->
  try
    structure = JSON.parse structure
    valid = true
  catch e
    valid = false
  finally
    if valid
      _structure =
        records: []
      async.each structure, (algorithm, next) ->
        async.each nconf.get('parser:root:mandatoryFields'), (field, subNext) ->
          if not (field in _.keys algorithm) then subNext field else subNext()
        , (err) ->
          if err?
            logger.log 'info', "skipping algorithm=#{algorithm.name} because field=#{err} is missing in root view", 'Parser'
            next()
          else
            parser.parseDetails algorithm, (err) ->
              if err?
                logger.log 'info', err, 'Parser'
                next()
              else
                _structure.records.push algorithm
                next()
      , (err) ->
        if err?
          logger.log 'info', "could not parse algorithm error=#{err}", 'Parser'
        callback null, _structure
    else
      callback "not a valid JSON format for root=#{structure.name}"

parser.parseDetails = (algorithm, callback) ->

  settings =
    options:
      uri: algorithm.url
      timeout: 8000
      headers: {}
    retries: nconf.get 'loader:retries'

  loader.get settings, (err, details) ->
    try
      details = JSON.parse details
      valid = true
    catch e
      valid = false
    finally
      if valid
        async.each nconf.get('parser:details:mandatoryFields'), (field, next) ->
          if not (field in _.keys details) then next field else next()
        , (err) ->
          if err?
            callback "skipping algorithm=#{algorithm.name} because field=#{err} is missing in details view"
          else
            callback()
      else
        callback "skipping algorithm=#{algorithm.name}, error=not a valid JSON format"
