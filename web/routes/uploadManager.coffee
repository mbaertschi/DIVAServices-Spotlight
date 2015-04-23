nconf     = require 'nconf'
mongoose  = require 'mongoose'
fs        = require 'fs-extra'
logger    = require '../lib/logger'

uploader = exports = module.exports = (router) ->

  router.get '/upload', (req, res) ->
    Image = mongoose.model 'Image'

    params =
      sessionId: req.sessionID
      processType: 'upload'

    Image.find params, (err, images) ->
      if err?
        logger.log 'warn', 'could not load images', 'UploadManager'
        res.status(404).json 'Error': 'Could not load images'
      else
        res.status(200).json images

  router.post '/upload', (req, res) ->
    if res.imageData?
      res.status(200).json res.imageData
    else
      serverName = clientName = req.body.filename
      Image = mongoose.model 'Image'
      url = 'public/uploads/' + req.sessionID + '/' + serverName
      path = '/uploads/' + req.sessionID + '/' + serverName

      query =
        sessionId: req.sessionID
        serverName: req.body.filename

      image =
        sessionId: req.sessionID
        serverName: serverName
        clientName: clientName
        size: null
        type: 'image/png'
        extension: 'png'
        url: url
        path: path
        processType: req.body.processType
        index: req.body.index

      res.imageData = image

      Image.update query, image, upsert: true, (err) ->
        logger.log 'warn', 'could not save image', 'Uploader' if err?

        matches = req.body.file.match(/^data:([A-Za-z-+\/]+);base64,(.+)$/)
        imageBuffer = {}

        if (matches.length isnt 3)
          logger.log 'warn', 'invalid input string for image', 'UploadManager'
          res.status(404).json Error: 'Invalid input string'
        else
          imageBuffer.type = matches[1];
          imageBuffer.data = new Buffer(matches[2], 'base64');

          fs.ensureDirSync 'public/uploads/' + image.sessionId

          fs.writeFile url, imageBuffer.data, (err) ->
            logger.log 'warn', 'there was an error while storing one of the images', 'UploadManager' if err?

          res.status(200).json res.imageData

  router.delete '/upload', (req, res) ->
    if req.query.serverName? and req.sessionID?
      Image = mongoose.model 'Image'

      query =
        sessionId: req.sessionID
        serverName: req.query.serverName

      Image.find query, (err, images) ->
        if err?
          res.send(404).json 'Error': 'Could not delete image'
        else
          for image in images
            fs.removeSync image.path
          Image.remove(query).exec()
          res.sendStatus(200)
    else
      res.sendStatus(200)
