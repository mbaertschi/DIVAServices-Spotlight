logger      = require './logger'
nconf       = require 'nconf'
mongoose    = require 'mongoose'

mongo = exports = module.exports = class Mongo

  constructor: ->
    logger.log 'info', 'initializing db connection', 'Mongo'
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

  getHosts: (callback) =>
    query = {}

    fields =
      host: true
      url: true

    @Host.find query, fields, (err, hosts) ->
      return callback err if err?
      callback null, hosts

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

  getAlgorithms: (callback) =>
    query = {}

    fields =
      name: true
      description: true
      url: true
      host: true

    @Algorithm.find query, fields, (err, algorithms) ->
      return callback err if err?
      if algorithms.length > 0
        callback null, algorithms
      else
        callback()
