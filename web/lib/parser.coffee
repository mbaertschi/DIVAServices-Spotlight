# Parser
# ======
#
# **Parser** is responsible for validating JSON objects we receive by polling
# the REST-Servers. It makes use of [JSON-Schema](http://json-schema.org/) for
# easily validating JSON objects.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
logger      = require './logger'
nconf       = require 'nconf'
async       = require 'async'
_           = require 'lodash'
loader      = require './loader'
Validator   = require('jsonschema').Validator
validator   = new Validator

# Expose parser
parser = exports = module.exports = {}

# ---
# **parser.parseRoot**</br>
# Parses the structure of the root entry (www.xyz.com/) for the currently polled
# host. If the structure passes the validation against the `hostSchema` specified
# in `./web/conf/server.[dev/prod].json`, then all its entries are validated against
# the `algorithmSchema`. Each algorithm which is valid, will be stored in mongoDB
# for that host</br>
# `params:`
#   * *structure* `<Object>` the JSON object which we received from the currently
#   polled host
parser.parseRoot = (structure, callback) ->
  try
    structure = JSON.parse structure
    valid = true
  catch e
    valid = false
  finally
    if valid
      hostErrors = validator.validate(structure, nconf.get('parser:root:hostSchema')).errors
      if hostErrors.length
        callback hostErrors[0].message
      else
        _structure =
          records: []
        async.each structure, (algorithm, next) ->
          algorithmErrors = validator.validate(algorithm, nconf.get('parser:root:algorithmSchema')).errors
          if algorithmErrors.length
            logger.log 'info', "skipping algorithm=#{algorithm.name} error=#{algorithmErrors[0].message} view=root view", 'Parser'
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
      callback "not a valid JSON format"

# ---
# **parser.parseDetails**</br>
# Parses the detailed information of an algorithm which we receive by calling its url.
# The information is validated against the `algorithmSchema` specified in
# `./web/conf/server.[dev/prod].json`</br>
# `params:`
#   * *algorithm* `<Object>` JSON object received by calling the algorithms url
parser.parseDetails = (algorithm, callback) ->

  settings =
    options:
      uri: algorithm.url
      timeout: 8000
      headers: {}
    retries: nconf.get 'loader:retries'

  loader.get settings, (err, details) ->
    if err?
      callback "skipping algorithm=#{algorithm.name} error=#{err}"
    else
      try
        details = JSON.parse details
        valid = true
      catch e
        valid = false
      finally
        if valid
          algorithmErrors = validator.validate(details, nconf.get('parser:details:algorithmSchema')).errors
          if algorithmErrors.length
            values = algorithmErrors[0].stack.split('.')
            errorMessage = values[values.length-1]
            callback "skipping algorithm=#{algorithm.name} error=#{errorMessage} view=details view"
          else
            callback()
        else
          callback "skipping algorithm=#{algorithm.name}, error=not a valid JSON format"
