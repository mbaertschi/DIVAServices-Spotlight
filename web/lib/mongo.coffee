# Mongo
# ======
#
# **Mongo** is responsible handling the mongoDB connection, its schemas and
# its interaction. It makes use of [mongoose](http://mongoosejs.com/) for
# having a nicely representation of the stored documents.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
logger      = require './logger'
nconf       = require 'nconf'
mongoose    = require 'mongoose'

# Expose mongo
mongo = exports = module.exports = class Mongo

  # ---
  # **constructor**</br>
  # Open connection to mongoDB and register schemas
  constructor: ->
    logger.log 'info', 'initializing', 'Mongo'
    url = nconf.get 'mongoDB:url'
    mongoose.connect "mongodb://#{url}"
    @db = mongoose.connection
    @Host = require './models/host'
    @Algorithm = require './models/algorithm'
    @Image = require './models/image'

    @db.once 'open', ->
      logger.log 'info', 'mongoose db connection opened', 'Mongo'

    @db.on 'error', (err) ->
      logger.log 'error', "mongoose err=#{err}", 'Mongo'

    @db.on 'parseError', (err) ->
      logger.log 'error', 'mongoose parseError check mongodb log', 'Mongo'
      setTimeout (-> process.exit(1)), 1000

  # ---
  # **getHosts**</br>
  # Returns all hosts currently stored in mongoDB
  getHosts: (callback) =>
    query = {}

    fields =
      host: true
      url: true

    @Host.find query, fields, (err, hosts) ->
      return callback err if err?
      callback null, hosts

  # ---
  # **getAlgorithm**</br>
  # Returns the algorithm associated to the passed url</br>
  # `params:`
  #   * *url* `<String>` url to match against algorithms in mongoDB
  getAlgorithm: (url, callback) =>
    query =
      url: url

    fields =
      name: true
      description: true
      url: true
      host: true

    @Algorithm.find query, fields, (err, algorithm) ->
      return callback err if err?
      if algorithm.length > 0
        callback null, algorithm[0]
      else
        callback()

  # ---
  # **getAlgorithms**</br>
  # Returns all algorithms currently stored in mongoDB
  getAlgorithms: (callback) =>
    query = {}

    fields =
      name: true
      description: true
      type: true
      url: true
      host: true

    @Algorithm.find query, fields, (err, algorithms) ->
      return callback err if err?
      if algorithms.length > 0
        callback null, algorithms
      else
        callback()
