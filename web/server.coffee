if not process.env.NODE_ENV? or process.env.NODE_ENV not in ['dev', 'prod']
  console.log 'please set NODE_ENV to [dev, prod]. going to exit'
  process.exit(0)

nconf       = require 'nconf'
nconf.file './conf/server.' + process.env.NODE_ENV + '.json'

express     = require 'express'
http        = require 'http'
sysPath     = require 'path'
slashes     = require 'connect-slashes'
bodyParser  = require 'body-parser'
router      = require './routes/router'
Poller      = require './lib/poller'
Pusher      = require './lib/pusher'
Mongo       = require './lib/mongo'

# start the web service
exports.startServer = (port, path, callback) ->

  # initialize the mongoDB
  @db = new Mongo

  # setup express framework
  app = express()
  # route all static files to http paths.
  app.use '', express.static(sysPath.resolve(path))
  # redirect requests that include a trailing slash.
  app.use slashes(false)
  # enable body parsing for json
  app.use bodyParser.json()

  # routing
  app.use router
  # route all non-existent files to `index.html`
  app.all '*', (req, res) ->
    res.sendfile sysPath.join(path, 'index.html')

  # wrap express with httpServer for socket.io
  app.server = http.createServer app
  app.server.timeout = 2000

  # start the pusher if defined
  if nconf.get 'pusher:run'
    io = require('socket.io')(app.server)
    pusher = new Pusher io

  # start the poller if defined
  if nconf.get 'poller:run'
    if nconf.get 'pusher:run'
      poller = new Poller @db, pusher
    else
      poller = new Poller @db
    poller.run()

  app.server.listen port, callback
