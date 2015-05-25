# SessionStore
# ============
#
# **SessionStore** uses express-session middleware to handle sessions. See docs at
# `https://github.com/expressjs/session` for detailed information. Sessions are
# associated to a SessionStore by the connectMongo middleware which is a slightly
# adapted version of connect-mongo. See docs at `https://github.com/kcbanner/connect-mongo`
# for detailed information.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
mongoose    = require 'mongoose'
nconf       = require 'nconf'
logger      = require './logger'

# Expose sessionStore
sessionStore = exports = module.exports = class SessionStore

  # ---
  # **constructor**</br>
  # Create an express-session and associate it with connectMongo</br>
  # `params:`
  #   * *session* `<express-session>` the express-session instance
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

    return @session
