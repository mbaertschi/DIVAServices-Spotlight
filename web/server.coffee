# Server
# ======
#
# **Server** is the main entry point for running the DIVAServices Spotlight application. DIVAServices Spotlight
# is running on an [nodeJS](https://nodejs.org/) plattform and uses the [Express](http://expressjs.com/)
# framework.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Set the `NODE_ENV` environment variable to `dev`, `test`, or `prod` depending on whether you are
# in development mode, in testing mode, or in production mode
if not process.env.NODE_ENV? or process.env.NODE_ENV not in ['dev', 'test', 'prod']
  console.log 'please set NODE_ENV to [dev, test, prod]. going to exit'
  process.exit 0

# Load the configuration files. We use `nconf` for managing
# our application settings
nconf = require 'nconf'
nconf.add 'server', type: 'file', file: './conf/server.' + process.env.NODE_ENV + '.json'
nconf.add 'client', type: 'file', file: './conf/client.' + process.env.NODE_ENV + '.json'
nconf.add 'schemas', type: 'file', file: './conf/schemas.json'

# Module dependencies
express     = require 'express'
session     = require 'express-session'
http        = require 'http'
sysPath     = require 'path'
slashes     = require 'connect-slashes'
bodyParser  = require 'body-parser'
router      = require './routes/router'
Poller      = require './lib/poller'
Pusher      = require './lib/pusher'
Mongo       = require './lib/mongo'
mongoose    = require 'mongoose'
SessionStore= require './lib/sessionStore'
Uploader    = require './routes/uploader'

# Expose `server`
server = exports = module.exports = {}

# Export `startServer` function which is used by [Brunch](http://brunch.io/)
server.startServer = (port, path, callback) ->

  # Initialize our `mongoDB`
  @db = new Mongo

  # Setup `Express` framework
  app = express()

  # Setup sessions. We use a session store which uses a mongoDB connection
  # to store the sessions in. This allows us to hook into the session destroy
  # method and handle image deletion (on disk and in mongoDB)
  sessionStore = new SessionStore session
  app.use session sessionStore

  # Route all static files to http paths
  app.use '', express.static sysPath.resolve path

  # Redirect requests that include a trailing slash
  app.use slashes false

  # Enable multipart/form-data. We use `multer` as middleware
  uploader = new Uploader
  app.use uploader

  # Enable body parser for json
  app.use bodyParser.json()

  # Setup our routes
  app.use router

  # Route all non-existent files to `index.html`
  app.all '*', (req, res) ->
    res.sendFile __dirname + '/' + sysPath.join path, 'index.html'

  # Wrap `Express` with `httpServer` for `socket.io`
  app.server = http.createServer app

  # Set server timeout to value specified in configuration file
  app.server.timeout = nconf.get 'server:timeout'

  # Start the `pusher` if defined so
  if nconf.get 'pusher:run'
    io = require('socket.io')(app.server)
    pusher = new Pusher io

  # Start the `poller` if defined so
  if nconf.get 'poller:run'
    if nconf.get 'pusher:run'
      poller = new Poller @db, pusher
    else
      poller = new Poller @db
    poller.run()

  # Start server on port specified in configuration file
  app.server.listen port, callback

# On production mode start server without brunch
if process.env.NODE_ENV is 'prod'
  server.startServer nconf.get('server:port'), nconf.get('server:path'), ->
