nconf     = require 'nconf'
mongoose  = require 'mongoose'
fs        = require 'fs-extra'
logger    = require '../lib/logger'
ExifImage = require('exif').ExifImage
lwip      = require 'lwip'

uploader = exports = module.exports = (router) ->

  router.get '/upload', (req, res) ->
    Image = mongoose.model 'Image'

    params =
      sessionId: req.sessionID
      # processType: 'upload'

    Image.find params, (err, images) ->
      if err?
        logger.log 'warn', 'could not load images', 'UploadManager'
        res.status(404).json 'Error': 'Could not load images'
      else
        res.status(200).json images

  router.post '/upload', (req, res) ->

    getRotation = (image, callback) ->
      try
        new ExifImage image: image.path, (err, exifData) ->
          if err
            callback "could not extract exif meta-data from image=#{image.serverName} error=#{err}"
          else
            if exifData.image
              rotate = 0
              switch exifData.image.Orientation
                when 3, 4 then rotate = 180
                when 5, 6 then rotate = 90
                when 7, 8 then rotate = 270
                else rotate = 0
              callback null, rotate
            else callback null, 0
      catch err
        callback "could not load ExifImage on image=#{image.serverName} error=#{err}"

    orientateJpegImage = (image, callback) ->
      if image.type is 'image/jpeg'
        path = image.path
        getRotation image, (err, rotate) ->
          if err
            logger.log 'info', err, 'UploadManager'
            callback()
          else
            if rotate
              lwip.open path, (err, img) ->
                if err
                  logger.log 'info', "lwip could not load image=#{image.serverName} error=#{err}", 'UploadManager'
                  callback()
                else
                  img.batch().rotate(rotate).writeFile path, (err) ->
                    if err then logger.log 'info', "lwip could not rotate image=#{image.serverName} error=#{err}", 'UploadManager'
                    callback()
            else
              callback()
      else callback()

    if res.imageData?
      # file was handled by multer
      orientateJpegImage res.imageData, ->
        res.status(200).json res.imageData
    else

      getFilesizeInBytes = (filename) ->
        stats = fs.statSync(filename)
        fileSizeInBytes = stats['size']
        fileSizeInBytes

      # write the image to uploads folder
      writeImage = (path, sessionId, callback) ->
        matches = req.body.file.match(/^data:([A-Za-z-+\/]+);base64,(.+)$/)
        imageBuffer = {}

        if (matches.length isnt 3)
          logger.log 'warn', 'invalid input string for image', 'UploadManager'
          callback 'Invalid input string'
        else
          imageBuffer.type = matches[1];
          imageBuffer.data = new Buffer(matches[2], 'base64');

          fs.ensureDirSync 'public/uploads/' + sessionId

          fs.writeFile path, imageBuffer.data, (err) ->
            if err?
              logger.log 'warn', 'there was an error while storing one of the images', 'UploadManager'
              callback err
            else
              callback null, getFilesizeInBytes(path)

      serverName = clientName = req.body.filename
      Image = mongoose.model 'Image'
      url = '/uploads/' + req.sessionID + '/' + serverName
      path = 'public/uploads/' + req.sessionID + '/' + serverName

      writeImage path, req.sessionID, (err, size) ->
        if err?
          res.status(404).json Error: err
        else
          query =
            sessionId: req.sessionID
            serverName: req.body.filename

          image =
            sessionId: req.sessionID
            serverName: serverName
            clientName: clientName
            size: size
            type: 'image/png'
            extension: 'png'
            url: url
            path: path
            processType: req.body.processType
            index: req.body.index

          res.imageData = image

          Image.update query, image, upsert: true, (err) ->
            if err?
              logger.log 'warn', 'could not save image', 'Uploader'
              res.status(404).json Error: 'Could not save image'
            else
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
