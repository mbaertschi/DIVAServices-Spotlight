fse         = require 'fs-extra'
nconf       = require 'nconf'
_           = require 'lodash'
loader      = require '../lib/loader'

api = exports = module.exports = {}

api.algorithms = (req, res) ->
  dir = nconf.get 'parser:fileLocation'
  fse.readJson dir, (err, structure) ->
    if err?
      res.status(404).json error: 'There was an error while loading the algorithms'
    else if _.isEqual({}, structure)
      res.status(404).json error: 'Not found'
    else
      res.status(200).json structure

api.algorithm = (req, res) ->
  return res.status(404).json 'error': 'Not found' if not req.body?.url
  url = req.body.url

  settings =
    options:
      uri: url
      timeout: 8000
      headers: {}
    retries: nconf.get 'poller:retries'

  loader.get settings, (err, resp) ->
    return res.status(404).json 'error': 'Algorithm could not be loaded' if err?
    res.status(200).json resp
