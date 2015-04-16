mongoose    = require 'mongoose'
nconf       = require 'nconf'
logger      = require './logger'

sessionStore = exports = module.exports = class SessionStore

  constructor: (session) ->
    logger.log 'info', 'initializing', 'SessionStore'

    MongoStore = require('./connectMongo')(session)

    @session =
      secret: nconf.get 'session:secret'
      resave: nconf.get 'session:resave'
      saveUninitialized: nconf.get 'session:saveUninitialized'
      rolling: true
      cookie: maxAge: nconf.get 'session:maxAge'
      store: new MongoStore mongooseConnection: mongoose.connection

  session: =>
    @session
