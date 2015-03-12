if not process.env.NODE_ENV? or process.env.NODE_ENV not in ['dev', 'prod']
  console.log 'please set NODE_ENV to [dev, prod]. going to exit'
  process.exit(0)

nconf       = require 'nconf'
nconf.file './conf/server.' + process.env.NODE_ENV + '.json'

express     = require 'express'
http        = require 'http'
sysPath     = require 'path'
slashes     = require 'connect-slashes'
fse         = require 'fs-extra'
_           = require 'lodash'
api         = require './routes/api'
Poller      = require './lib/poller'

# start the web service
exports.startServer = (port, path, callback) ->

  app = express()
  server = http.Server app
  server.timeout = 2000

  io = require('socket.io')(server)
  io.on 'connection', require './routes/socket'


  # Route all static files to http paths.
  app.use '', express.static(sysPath.resolve(path))

  # Redirect requests that include a trailing slash.
  app.use slashes(false)

  app.get '/api/algorithms', api.algorithms

  app.post '/api/algorithm', api.algorithm

  # Route all non-existent files to `index.html`
  app.all '*', (req, res) ->
    res.sendfile sysPath.join(path, 'index.html')

  # start the poller
  poller = new Poller(io)
  poller.run()

  server.listen port, callback
