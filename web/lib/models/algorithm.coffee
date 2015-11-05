# Algorithm
# =========
#
# **Algorithm** is the mongoose model for the algorithm schema.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
mongoose    = require 'mongoose'
_           = require 'lodash'
logger      = require '../logger'

# `Algorithm` schema definition
AlgorithmSchema = mongoose.Schema
  name: String
  description: String
  type: String
  url: String
  host: String
  _lastChange: Date

# Set the algorithms url as its index
AlgorithmSchema.index url: 1

# Set `_lastChange` attribute to current time before algorithm is updated
AlgorithmSchema.pre 'save', (next) ->
  @._lastChange = new Date
  next()

# ---
# **AlgorithmSchema.methods.compareAndSave**</br>
# Expose `compareAndSave` method on `Algorithm` schema. `compareAndSave` takes
# the new algorithm as parameter input and compares each attributes value against
# the old algorithm stored in the mongoDB. If there are any changes, the algorithm
# will be updated</br>
# `params:`
#   * *algorithm* `<Object>` to compare against algorithm stored in mongoDB
AlgorithmSchema.methods.compareAndSave = (algorithm, callback) ->
  doc = @
  Algorithm = mongoose.model 'Algorithm'
  newAlgorithm = new Algorithm(algorithm).toObject()
  oldAlgorithm = @.toObject()

  changes = _findDifferences newAlgorithm, oldAlgorithm

  if changes.length > 0
    for change in changes
      doc[change.attr] = change.new

    doc.save (err, algorithm) ->
      if err
        logger.log 'error', 'there was an error while storing changed algorithm. Check mongoose log', 'Algorithm'
      callback null, changes, doc

  else
    callback null, changes, doc

# ---
# **_findDifferences**</br>
# Recursively iterate over all attributes and return differences if there are any</br>
# `params:`
#   * *newObj* `<Object>` the new object to be compared
#   * *oldObj* `<Object>` the old object to be compared
#   * *scope* `<String>` (optional) scope to apply this method on
_findDifferences = (newObj, oldObj, scope) ->
  scope or (scope = '')
  differences = []

  keys1 = _.chain(newObj).keys().filter((key) ->
    key.search('_') != 0
  ).value()

  keys2 = _.chain(oldObj).keys().filter((key) ->
    key.search('_') != 0
  ).value()

  keyDiff = _.difference(keys1, keys2).concat(_.difference(keys2, keys1))

  if keyDiff.length > 0
    _.each keyDiff, (key) ->
      if _.isObject(newObj[key]) and _.isObject(oldObj[key])
        differences = differences.concat(_findDifferences(newObj[key], oldObj[key]), scope + key + '.')
      else
        if key in newObj
          differences.push
            type: 'new attr'
            attr: scope + key
            new: newObj[key]
            old: undefined
        else if oldObj[key] != null
          differences.push
            type: 'del attr'
            attr: scope + key
            new: undefined
            old: oldObj[key]

  keyIntersection = _.intersection keys1, keys2

  _.each keyIntersection, (key) ->
    if _.isObject(newObj[key]) and _.isObject(oldObj[key]) and _.isDate(newObj[key]) is false and _.isDate(oldObj[key]) is false and _.isArray(newObj[key]) is false and _.isArray(oldObj[key]) is false
      differences = differences.concat(_findDifferences(newObj[key], oldObj[key], scope + key + '.'))
    else
      v1 = newObj[key]
      v2 = oldObj[key]
      if _.isDate(v1)
        v1 = v1.toString()
      if _.isDate(v2)
        v2 = v2.toString()
      if _.isArray(v1) and _.isArray(v2)
        diff = objectDiff.diffOwnProperties(v1, v2)
        if diff.changed != 'equal'
          differences.push
            type: 'mod attr'
            attr: scope + key
            new: v1
            old: v2
        return true
      if _.isArray(v1)
        v1 = JSON.stringify(v1)
      if _.isArray(v2)
        v2 = JSON.stringify(v2)
      if v1 != v2
        differences.push
          type: 'mod attr'
          attr: scope + key
          new: v1
          old: v2
  differences

# Expose `Algorithm` schema
module.exports = mongoose.model 'Algorithm', AlgorithmSchema
