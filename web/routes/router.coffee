# Router
# =======
#
# **Router** uses the [Express > Router](http://expressjs.com/api.html#router) middleware
# for handling all routing from DIVAServices Spotlight.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Require Express Router
router      = require('express').Router()

# Pass Express Router to all routing modules
api         = require('./api')(router)
uploader    = require('./uploadManager')(router)

# Expose router
module.exports = router
