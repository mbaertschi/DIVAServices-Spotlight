# Logger
# ======
#
# **Logger** makes use of [Log4js](http://stritti.github.io/log4js/docu/users-guide.html)
# to abstract the logging functionality.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
log4js      = require 'log4js'
nconf       = require 'nconf'
nodemailer  = require('nodemailer')
transporter = nodemailer.createTransport()

# Load loggers defined in `./web/conf/server.[dev/prod].json`
log4js.configure appenders: nconf.get 'logger:appenders'
logger = log4js.getLogger 'server'
logger.setLevel nconf.get 'logger:level'

# ---
# **sendMail**</br>
# Iteratively flushes the message queue and sends the logged error messages
# to the specified eMail addresses
sendMail = =>
  skipMessages = [
    /Error: This is a sample skip message/
  ]

  errorMessages = ''
  for msg in @queue
    skip = false
    for reg in skipMessages
      if reg.test msg then skip = true
    if not skip then errorMessages += msg + "\n"

  @queue = []

  if errorMessages isnt ''
    mailAddresses = nconf.get('logger:mailAddresses')
    for mailAddress in mailAddresses
      transporter.sendMail {
        from: 'info@divaservices.ch'
        to: mailAddress
        subject: "DivaServices Spotlight Error(s)"
        text: errorMessages
      }, (err) ->
        console.log "there was an error while sending mail to #{mailAddress}" if err?

# ---
# **exports.init**</br>
# Expose init method</br>
# Inits the message queue which is flushed every 5 minutes to send the logged
# error messages to the specified eMail addresses
exports.init = ->
  @queue = []
  setInterval sendMail, nconf.get('logger:interval')

# ---
# **exports.log**</br>
# Expose log method</br>
# `params:`
#   * *level* `<String>` must be one of [fatal, error, warn, info, debug, trace, all]
#   * *msg* `<String>` the message to log
#   * *module* `<String>` (optional) which module sent the log message
exports.log = (level, msg, module) =>
  level = level || 'info'

  if level in nconf.get('logger:mailLevels')
    @queue.push "#{new Date} level=#{level} module=#{module} #{msg}"

  if module?
    logger[level] msg + " [#{module}]"
  else
    logger[level] msg
