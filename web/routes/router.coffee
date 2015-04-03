router      = require('express').Router()
api         = require('./api')(router)
uploader    = require('./uploadManager')(router)

module.exports = router
