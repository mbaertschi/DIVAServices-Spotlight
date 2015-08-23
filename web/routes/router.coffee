# Router
# =======
#
# **Router** uses the [Express > Router](http://expressjs.com/api.html#router) middleware
# for handling all routing from DIVAServices Spotlight.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Require Express Router
router      = require('express').Router()

# Expose router
module.exports = (poller) ->
  require('./api')(router, poller)
  require('./uploadManager')(router)
  router
