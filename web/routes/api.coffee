nconf       = require 'nconf'
loader      = require '../lib/loader'
mongoose    = require 'mongoose'

api = exports = module.exports = (router) ->

  router.get '/api/settings', (req, res) ->
    params = req.query

    if params.type?
      settings = nconf.get "web:#{params.type}"
    else
      settings = nconf.get 'web'

    res.status(200).json settings

  router.get '/api/algorithms', (req, res) ->
    Algorithm = mongoose.model 'Algorithm'

    fields =
      name: true
      description: true
      url: true
      host: true

    Algorithm.find {}, fields, (err, algorithms) ->
      if err?
        res.status(404).json error: 'There was an error while loading the algorithms'
      else if algorithms.length is 0
        res.status(404).json error: 'Not found'
      else
        res.status(200).json algorithms

  router.get '/api/algorithm', (req, res) ->
    params = req.query
    return res.status(404).json 'error': 'Not found' if not params.id

    Algorithm = mongoose.model 'Algorithm'
    Algorithm.findById params.id, (err, algorithm) ->
      if err
        res.status(404).json error: 'Not found'
      else
        url = algorithm.url

        settings =
          options:
            uri: url
            timeout: 8000
            headers: {}
          retries: nconf.get 'poller:retries'

        loader.get settings, (err, resp) ->
          return res.status(404).json 'error': 'Algorithm could not be loaded' if err?
          res.status(200).json resp
