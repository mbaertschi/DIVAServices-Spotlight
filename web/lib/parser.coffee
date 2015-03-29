logger      = require './logger'
nconf       = require 'nconf'
_           = require 'lodash'

parser = exports = module.exports = {}

parser.parse = (structure, callback) ->
  try
    structure = JSON.parse structure
    valid = true
  catch e
    valid = false
  finally
    if valid
      _structure =
        records: []
      _.forIn structure, (algorithm, key) ->
        skip = false
        _.each nconf.get('parser:mandatoryFields'), (field) ->
          if not (field in _.keys algorithm)
            logger.log 'info', "skipping algorithm #{algorithm.name} because field #{field} is missing", 'Parser'
            skip = true
          else
            skip = false
        if not skip
          _structure.records.push algorithm
      callback null, _structure
    else
      callback 'Not a valid JSON format'
