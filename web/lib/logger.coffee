log4js      = require 'log4js'
nconf       = require 'nconf'

log4js.configure appenders: nconf.get 'logger:appenders'
logger = log4js.getLogger 'server'
logger.setLevel nconf.get 'logger:level'

exports.log = (level, msg, module) ->
  level = level || 'info'

  if module?
    logger[level] msg + " [#{module}]"
  else
    logger[level] msg
