# UploadManager
# =============
#
# **UploadManager** exposes all routes need for image handling. Images which are
# uploaded by [Dropzone](http://www.dropzonejs.com/) are first handled by
# `multer` middleware and then passed on to `UploadManager`
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
mongoose  = require 'mongoose'
fs        = require 'fs-extra'
logger    = require '../lib/logger'
loader    = require '../lib/loader'
nconf     = require 'nconf'
async     = require 'async'
utils     = require './utils'

# Expose uploadManager routes
uploadManager = exports = module.exports = (router) ->

  # ----and
  # **router.get** `/upload`
  #   * method: GET
  #   * params: none
  #   * return: All images assigned to the requests sessionId
  #
  # If there are any images in mongoDB which do not exists
  # on disk anymore, they will be removed from mongoDB
  router.get '/upload', (req, res) ->
    Image = mongoose.model 'Image'
    validImages =[]
    invalidImages = []

    removeInvalidImages = ->
      async.each invalidImages, (image, next) ->
        query =
          path: image.path
        Image.remove query, (err) ->
          next err
      , (err) ->
        if err? then logger.log 'warning', "could not remove invalid images error=#{err}", 'UploadManager'

    params =
      sessionId: req.sessionID

    Image.find params, (err, images) ->
      if err?
        logger.log 'warn', 'could not load images', 'UploadManager'
        res.status(404).json 'Error': 'Could not load images'
      else
        async.each images, (image, next) ->
          fs.stat image.path, (err, stats) ->
            if err?
              logger.log 'debug', "skipping image=#{image.path} reason=missing", 'UploadManager'
              invalidImages.push image
            else
              validImages.push image
            next()
        , (err) ->
          if err? then logger.log 'warning', "could not ensure that images exists error=#{err}", 'UploadManager'
          res.status(200).json validImages
          removeInvalidImages()

  # ---
  # **router.post** `/upload`
  #   * method: POST
  #   * params: none
  #   * return: The uploaded image information from mongoDB
  #
  # This is a special route which gets called when an image is uploaded by `Dropzone`. In
  # this case, the image was preprocessed by `multer` middleware and all the mandatory
  # data is passed on in `res.imageData` field. This method postprocesses the image with
  # the following steps:
  #   1. Orientate image (only for .jpeg images which have exif-metadata)
  #   2. Resize image
  #   3. Convert image to .png
  #   4. Create a thumbnail for that image
  router.post '/upload', (req, res) ->
    query =
      sessionId: res.imageData.sessionId
      serverName: res.imageData.serverName
    
    Host = mongoose.model 'Host'
    Host.find {}, (err, hosts) ->
      host = hosts[0]
      
      body =
        files: [
          {
            type: "image"
            value: res.imageData.base64
          }
        ]
      settings =
        options:
          uri: host.url + '/upload'
          timeout: nconf.get 'server:timeout'
          headers: {}
          method: 'POST'
          json: true
    
      loader.post settings, body, (err, result) ->
        utils.processImage res.imageData, ->
          utils.convertToPng res.imageData, (err, image) ->
            utils.createThumbnail image, (err, thumbPath, thumbUrl) ->
              image.thumbPath = thumbPath
              image.thumbUrl = thumbUrl
              image.coll = result.collection
              Image = mongoose.model 'Image'
              Image.update query, image, upsert: true, (err) ->
                if err? then logger.log 'info', "could not store image=#{image.serverName} error=#{err}", 'UploadManager'
                res.imageData = image
                res.status(200).json res.imageData
              

  # ---
  # **router.put** `/upload`
  #   * method: PUT
  #   * params:
  #     * *serverName* `<String>` the images name associated on the server
  #     * *file* `<String>` base64 image
  #   * return: updated image information from mongoDB
  #
  # Updates the given image and its thumbnail
  router.put '/upload', (req, res) ->
    serverName = req.body.filename
    Image = mongoose.model 'Image'

    query =
      sessionId: req.sessionID
      serverName: serverName

    Image.find query, (err, images) ->
      if err?
        logger.log 'warn', 'could not load image', 'Uploader'
        res.status(404).json Error: 'Could not load image'
      else
        image = images[0]

        utils.writeImage image, req.body.file, (err, size) ->
          if err?
            res.status(404).json Error: err
          else
            utils.createThumbnail image, (err, thumbPath, thumbUrl) ->
              image.thumbPath = thumbPath
              image.thumbUrl = thumbUrl
              image.size = size

              res.imageData = image

              Image.update query, image.toObject(), upsert: true, (err) ->
                if err?
                  logger.log 'warn', 'could not save image', 'Uploader'
                  res.status(404).json Error: 'Could not save image'
                else
                  res.status(200).json res.imageData

  # ---
  # **router.delete** `/upload`
  #   * method: DELETE
  #   * params:
  #     * *serverName* `<String>` the images name associated on the server
  #   * return: none
  #
  # Removes the given image and its thumbnail from disk and deletes the mongoDB entry
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
            if image.thumbPath and (image.path isnt image.thumbPath)
              fs.removeSync image.thumbPath
          Image.remove(query).exec()
          res.sendStatus(200)
    else
      res.sendStatus(200)
