log4js      = require 'log4js'
nconf       = require 'nconf'

log4js.configure appenders: nconf.get 'logger'
logger = log4js.getLogger 'server'

exports.log = (level, msg, module) ->
  level = level || 'info'

  if module?
    logger[level] msg + " [#{module}]"
  else
    logger[level] msg
