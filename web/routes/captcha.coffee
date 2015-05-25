# Captcha
# =======
#
# **Captcha** exposes all routes needed for captcha creation and validation.
# See docs at [visualCaptcha](http://visualcaptcha.net/) for detailed information.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
nconf       = require 'nconf'

# Expose captcha routes
captcha = exports = module.exports = (router) ->

  router.get '/captcha/audio', (req, res, next) ->
    visualCaptcha = require('visualcaptcha')(req.session, req.query.namespace)
    visualCaptcha.streamAudio res, 'mp3'

  router.get '/captcha/image/:index', (req, res, next) ->
    visualCaptcha = require('visualcaptcha')(req.session, req.query.namespace)
    if req.query.retina then isRetina = true else isRetina = false
    visualCaptcha.streamImage req.params.index, res, isRetina

  router.get '/captcha/start/:howmany', (req, res, next) ->
    visualCaptcha = require('visualcaptcha')(req.session, req.query.namespace)
    visualCaptcha.generate req.params.howmany
    res.status(200).send visualCaptcha.getFrontendData()

  router.post '/captcha/try', (req, res, next) ->
    visualCaptcha = require('visualcaptcha')(req.session, req.query.namespace)
    frontendData = visualCaptcha.getFrontendData()
    namespace = req.query.namespace
    queryParams = []

    if namespace and namespace.length isnt 0
      queryParams.push 'namespace=' + namespace

    if typeof frontendData is undefined
      queryParams.push 'status=noCaptcha'
      responseStatus = 404
    else
      if (imageAnswer = req.body[frontendData.imageFieldName])
        if visualCaptcha.validateImage(imageAnswer)
          queryParams.push 'status=validImage'
          responseStatus = 200
        else
          queryParams.push 'status=failedImage'
          responseStatus = 403
      else if (audioAnswer = req.body[frontendData.audioFieldName])
        if visualCaptcha.validateAudio(audioAnswer.toLowerCase())
          queryParams.push 'status=validAudio'
          responseStatus = 200
        else
          queryParams.push 'status=failedAudio'
          responseStatus = 403
      else
        queryParams.push 'status=failedPost'
        responseStatus = 500

    res.status(responseStatus).send queryParams
