if not process.env.NODE_ENV? or process.env.NODE_ENV not in ['dev', 'prod']
  console.log 'please set NODE_ENV to [dev, prod]. going to exit'
  process.exit(0)

nconf       = require 'nconf'
express     = require 'express'
http        = require 'http'
sysPath     = require 'path'
slashes     = require 'connect-slashes'
fse         = require 'fs-extra'
_           = require 'lodash'

nconf.file './conf/server.' + process.env.NODE_ENV + '.json'

# start the poller
poller = require './lib/poller'
poller.run()

# start the web service
exports.startServer = (port, path, callback) ->
  app = express()

  # Route all static files to http paths.
  app.use '', express.static(sysPath.resolve(path))

  # Redirect requests that include a trailing slash.
  app.use slashes(false)

  app.post '/algorithms', (req, res) ->
    console.log req.body
    res.json {test: 'test'}

  app.get '/algorithms', (req, res) ->
    dir = nconf.get 'parser:fileLocation'
    fse.readJson dir, (err, structure) ->
      if err?
        res.status(404).send err
      else if _.isEqual({}, structure)
        res.status(404).send 'Not found'
      else
        res.status(200).send structure

  # Route all non-existent files to `index.html`
  app.all '*', (req, res) ->
    res.sendfile sysPath.join(path, 'index.html')

  # Wrap express app with node.js server in order to have stuff like server.stop() etc.
  server = http.createServer app
  server.timeout = 2000

  server.listen port, callback
