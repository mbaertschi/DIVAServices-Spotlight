nconf       = require 'nconf'
nconf.file './conf/server.json'

Poller      = require './lib/poller'
webservice  = require './lib/webservice'

# start the poller
poller = new Poller
poller.run()

# start the web service
module.exports.startServer = webservice.startServer