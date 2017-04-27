# API
# ===
#
# **API** exposes all routes belonging to `/api/`.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
nconf       = require 'nconf'
loader      = require '../lib/loader'
mongoose    = require 'mongoose'
fs          = require 'fs-extra'
Validator   = require('jsonschema').Validator
validator   = new Validator
utils       = require './utils'
_           = require 'lodash'
gm          = require 'gm'
logger      = require '../lib/logger'
basicAuth   = require 'basic-auth'
md5         = require 'md5'
url         = require 'url'
request     = require('request').defaults(encoding: null)
async       = require 'async'

# Expose api routes
api = exports = module.exports = (router, poller) ->

  # ---
  # enable basic authorization if defined so in settings
  auth = (req, res, next) ->
    if nconf.get 'basicAuth:enabled'
      unauthorized = (res) ->
        res.set 'WWW-Authenticate', 'Basic realm=Authorization Required'
        res.sendStatus 401
      user = basicAuth req
      if !user or !user.name or !user.pass
        return unauthorized(res)
      if user.name is nconf.get('basicAuth:user') and user.pass is nconf.get('basicAuth:pass')
        next()
      else
        unauthorized res
    else
      next()

  # ---
  # **router.get** `/api/settings`
  #   * method: GET
  #   * params:
  #     * *type* `<String>` (optional) set type if you want to only fetch some parts of the
  #       client settings specified in `./web/conf/client.[dev/prod].json`
  #   * return: client side settings specified in `./web/conf/client.[dev/prod].json`
  router.get '/api/settings', (req, res) ->
    params = req.query

    if params.type?
      settings = nconf.get "web:#{params.type}"
    else
      settings = nconf.get 'web'

    res.status(200).json settings

  # ---
  # **router.get** `/api/sync`
  #   * method: GET
  #   * return: status of poller synchronization
  #
  # This route will manually trigger the poller to sync the algorithms
  router.get '/api/sync', auth, (req, res) ->
    poller.sync (err) ->
      if err?
        res.status(200).json status: err
      else
        res.status(200).json status: 'sync done'

  # ---
  # **router.get** `/api/algorithms`
  #   * method: GET
  #   * params: none
  #   * return: All algorithms currently stored in mongoDB
  router.get '/api/algorithms', (req, res) ->
    Algorithm = mongoose.model 'Algorithm'

    fields =
      name: true
      description: true
      type: true
      url: true
      host: true
      _lastChange: true

    Algorithm.find {}, fields, (err, algorithms) ->
      if err?
        res.status(404).json error: 'There was an error while loading the algorithms'
      else
        res.status(200).json algorithms

  # ---
  # **router.get** `/api/algorithm`
  #   * method: GET
  #   * params:
  #     * *id* `<String>` the algorithms id
  #   * return: algorithm details for algorithm with _id == id
  #
  # This method will first fetch the algorithm from mongoDB and then
  # calls the algorithms url to fetch the details from the remote host.
  # Those details are validated against the algorithm schema defined
  # in in `./web/conf/schemas.json`
  router.get '/api/algorithm', (req, res) ->
    params = req.query
    return res.status(404).json 'error': 'Not found' if not params.id

    Algorithm = mongoose.model 'Algorithm'
    Algorithm.findById params.id, (err, algorithm) ->
      if err or not algorithm?
        res.status(404).json error: 'Not found'
      else

        settings =
          options:
            uri: algorithm.url
            timeout: nconf.get 'server:timeout'
            headers: {}
          retries: nconf.get 'poller:retries'

        loader.get settings, (err, resp) ->
          return res.status(404).json 'error': 'Algorithm could not be loaded' if err?
          try
            details = JSON.parse resp
            valid = true
          catch e
            valid = false
          finally
            if valid
              algorithmDetailsErrors = validator.validate(details, nconf.get('detailsAlgorithmSchema')).errors
              if algorithmDetailsErrors.length
                res.status(400).json error: 'invalid json structure'
              else
                res.status(200).json details
            else
              res.status(400).json error: 'invalid json structure'


  #TODO Fix this route to properly delete the running process
  router.delete '/api/algorithm', (req, res) ->
    params = req.body
    params.started = false
    res.status(200).send
  # ---
  # **router.post** `/api/algorithm`
  #   * method: POST
  #   * params:
  #     * *algorithm* `<Object>` the algorithm to use
  #     * *image* `<Object>` the image to process
  #     * *inputs* `<Object>` additional information for the algorithm
  #   * return: the result of the algorithm applied on the image with the given additional information
  #
  # The algorithm and image objects must conform to the mongoDB schemas specified for them. The image will
  # be sent to the remote host as base64 encoded image along with the other information. The response from
  # the remote host must meet the JSON-Schema specification defined in `./web/conf/schemas.json`. If response
  # contains a base64 encoded image and storing result images is set to true in config file, the image will
  # be stored as .png image and passed on as result image. If storage is set to false, the dataUrl will be
  # passed on. If no result image is given the origin image will be passed on (if highlighters are defined in
  # response)
  router.post '/api/algorithm', (req, res) ->
    params = req.body
    return res.status(400).send() if not params.algorithm or not params.image or not params.inputs

    storeImage = (result, image, callback) ->
      logger.log 'info', result.outputImage
      request.get result.outputImage , (error, response, body) ->
        if !error and response.statusCode == 200
          buffer = 'data:' + response.headers['content-type'] + ';base64,' + new Buffer(body).toString('base64')
          logger.log 'info', 'writing file to: ' + image.path
          fs.writeFile image.path, buffer, (err) ->
            if err?
              logger.log 'warn', "fs could not write buffered image to disk error=#{err}", 'API'
              callback { status: 500, error: err}
            else
              image.size = utils.getFilesizeInBytes image.path
              utils.createThumbnail image, (err, thumbPath, thumbUrl) ->
                if err?
                  callback { status: 500, error: err}
                else
                  image.thumbPath = thumbPath
                  image.thumbUrl = thumbUrl
                  result.image = image
                  Image = mongoose.model 'Image'
                  query =
                    sessionId: req.sessionID
                    serverName: image.serverName
                  Image.update query, image, upsert: true, (err) ->
                    if err?
                      logger.log 'warn', 'could not save image', 'API'
                      callback { status: 500, error: err}
                    else
                      callback null, result

    processResponse = (result, callback) ->
      if(err?)
        logger.log 'error', err
      if result is 'ERROR'
        logger.log 'debug', "Remote host processing error for algorithm=#{params.algorithm.name}", 'API'
        return callback { status: 400, error: 'Remote host processing error'}
      responseErrors = validator.validate(result, nconf.get('responseSchema')).errors
      if responseErrors.length
        logger.log 'debug', "algorithm response is invalid object=#{JSON.stringify(result)}", 'API'
        logger.log 'debug', responseErrors[0]
        callback { status: 400, error: responseErrors[0].stack }
      else if result.outputImage?
        if /_output_/.test params.image.serverName
          serverName = params.image.serverName.split('_output_')[0] + '_output_' + new Date().getTime() + '.png'
        else
          serverName = params.image.serverName.replace '.png', '_output_' + new Date().getTime() + '.png'
        path = nconf.get('web:uploader:destination') + req.sessionID + '/' + serverName

        logger.log 'debug', JSON.stringify(params), 'API'

        image =
          serverName: serverName
          clientName: params.algorithm.general.name.trim().replace(' ', '_') + '_' + new Date().getTime() + '.png'
          sessionId: req.sessionID
          extension: 'png'
          type: 'image/png'
          path: path
          url: path.replace 'public', ''
        if nconf.get 'images:storeResponse'
          storeImage result, image, (err, result) ->
            callback err, result
        else
          image.dataUrl = result.outputImage
          image.saveButton = true
          result.image = image
          callback null, result
      else if result.highlighters?
        if nconf.get 'images:storeResponse'
          callback null, result
        else
          result.image = params.image
          getImageAsBase64 result.image.path, (err, base64Image) ->
            if err?
              logger.log 'warn', err, 'API'
              callback null, result
            else
              result.image.dataUrl = result.outputImage
              result.image.saveButton = true
              callback null, result
      else
        callback null, result

    Algorithm = mongoose.model 'Algorithm'
    Algorithm.findById params.algorithm.id, (err, algorithm) ->
      if err or not algorithm?
        res.status(404).send()
      else
        logger.log 'trace', url
        urlObj = url.parse(algorithm.url)
        baseUrl = urlObj.protocol + '//' + urlObj.host

        images = []
        #if image available add the md5 information
        imageBody =
          inputImage: params.image.coll + "/*"

        images.push imageBody
        #create the request body
        body =
          parameters: params.inputs
          data: images
        settings =
          options:
            uri: algorithm.url
            timeout: nconf.get 'server:timeout'
            headers: {}
            method: 'POST'
            json: true
        #execute POST request to start execution on the backend
        loader.post settings, body, (err, result) ->
          if err?
            if _.isNumber err
              logger.log 'error', err
              res.status(err).send()
            else
              logger.log 'error', err
              res.status(500).json err
          else if not result?
            res.status(500).json error: 'no response received'
          else
            #
            async.waterfall [
              (callback) ->
                logger.log 'info', 'url: '  + result.results[0].resultLink
                settings =
                  options:
                    uri: result.results[0].resultLink
                    timeout: nconf.get 'server:timeout'
                    headers:
                      'Content-Type': 'application/json'
                    method: 'GET'
                    json: true
                #poll in 5 second intervals for the results
                async.doUntil  ((cb) ->
                  loader.get settings, (err, result) ->
                    logger.log 'info', 'status: ' + result.status
                    if result.status is 'done'
                      params.started  = false
                      if(result.statusCode == 500)
                        error =
                          status: 500
                          error: result.statusMessage
                        cb error, null
                      else
                        cb null, result
                    else
                      setTimeout ( ->
                        cb null, result
                        return
                      ), 5000
                ),(->
                  params.started == false
                ),(err,result) ->
                  callback null, err, result
                  #process the result
              (error, result, callback) ->
                if(error?)
                  res.status(error.status).json error.error
                  callback error, null
                else
                  #check if a visualization file is available
                  files = _.filter(result.output, (entry) ->
                    return _.has(entry, 'file')
                  )
                  visualization = _.filter(files, (file) ->
                    return file.file.options.visualization
                  )
                  if visualization.size > 0 then resPayloadHasImage = true
                  processResponse result, (err, resultProcessed) ->
                    if err?
                      res.status(err.status).json err.error
                    else
                      resultProcessed.reqPayload = body
                      resultProcessed.resPayload =
                        output: result.output
                        highlighters: result.highlighters
                      if resPayloadHasImage then resultProcessed.resPayload.image = visualization[0]
                      callback null,resultProcessed
              ], (err, result) ->
                if(!err?)
                  logger.log 'trace', result
                  res.status(200).json result



  # ---
  # **router.post** `/api/image`
  #   * method: POST
  #   * params:
  #     * *base64Image* `<String>` base64 encoded image to store
  #     * *serverName* `<String>` images server name to be stored in mongoDB
  #     * *clientName* `<String>` images client name to be stored in mongoDB
  #     * *path* `<String>` images path to be stored in mongoDB
  #     * *url* `<String>` images url to be stored in mongoDB
  #
  # Saves an image to disk and to mongoDB
  router.post '/api/image', (req, res) ->
    params = req.body
    serverName = params.serverName.split('_')[0] + '_' + new Date().getTime()
    path = params.path.replace params.serverName, serverName
    if(params.image.startsWith('http://'))
      #download image
      request.get params.image, (error, response, body) ->
        if not error and response.statusCode is 200
           buffer = 'data:' + response.headers['content-type'] + ';base64,' + new Buffer(body).toString('base64')
           base64Image = buffer
           saveImage base64Image, params, path, serverName, req, res
    else
      base64Image = params.image
      saveImage base64Image, params, path, serverName, req, res

  saveImage = (base64Image, params, path, serverName, req,  res) ->
    Host = mongoose.model 'Host'
    Host.find {}, (err, hosts) ->
      host = hosts[0]

      body =
        images: [
          {
            type: "image"
            value: base64Image
          }
        ]
      settings =
        options:
          uri: algorithm.url
          timeout: nconf.get 'server:timeout'
          headers: {}
          method: 'POST'
          json: true

      loader.post settings, body, (err, result) ->

        image =
          serverName: serverName
          clientName: params.clientName
          coll: result.collection
          sessionId: req.sessionID
          extension: 'png'
          type: 'image/png'
          path: path
          url: params.url.replace params.serverName, serverName
          md5: md5(base64Image)

        utils.writeImage image, base64Image, (err, size) ->
          if err?
            res.status(500).json error: 'Could not save image to disk'
          else
            image.size = size
            utils.createThumbnail image, (err, thumbPath, thumbUrl) ->
              if err?
                callback { status: 500, error: err}
              else
                image.thumbPath = thumbPath
                image.thumbUrl = thumbUrl
                Image = mongoose.model 'Image'
                query =
                  sessionId: req.sessionID
                  serverName: image.serverName
                Image.update query, image, upsert: true, (err) ->
                  if err?
                    logger.log 'warn', 'could not save image', 'API'
                    res.status(500).json 'Could not save image to mongoDB'
                  else
                    res.status(200).send()
