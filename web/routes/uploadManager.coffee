nconf     = require 'nconf'
mongoose  = require 'mongoose'
fs        = require 'fs-extra'

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
