fse         = require 'fs-extra'
nconf       = require 'nconf'
_           = require 'lodash'

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
  console.log req
