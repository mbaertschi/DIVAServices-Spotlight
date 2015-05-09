router      = require('express').Router()
api         = require('./api')(router)
uploader    = require('./uploadManager')(router)
captcha     = require('./captcha')(router)

module.exports = router
