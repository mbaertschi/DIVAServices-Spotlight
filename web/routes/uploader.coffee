# Uploader
# ========
#
# **Uploader** makes use of the `multer` middleware for handling
# multipart/form-data. This module is mandatory when using Dropzone.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
multer      = require 'multer'
fs          = require 'fs-extra'
nconf       = require 'nconf'
mongoose    = require 'mongoose'
logger      = require '../lib/logger'

# Expose uploader
uploader = exports = module.exports = class Uploader

  # ---
  # **constructor**</br>
  # Configure multer settings. Images are renamed to upload\_[x] and
  # stored under `./public/uploads/[sessionId]/upload_[x]`. Once upload
  # has completed, all image information are stored in mongoDB
  constructor: ->
    @multer = multer
      dest: nconf.get 'web:uploader:destination'
      limits:
        fieldSize: nconf.get 'server:maxFileSize'
      rename: (fieldname, filename, req, res) ->
        name = 'upload_' + new Date().getTime()
        name
      changeDest: (dest, req, res) ->
        newPath = dest + req.sessionID
        fs.ensureDirSync newPath
        newPath
      onFileUploadComplete: (file, req, res) ->
        Image = mongoose.model 'Image'
        url = file.path.replace 'public', ''

        query =
          sessionId: req.sessionID
          serverName: file.name

        image =
          sessionId: req.sessionID
          serverName: file.name
          clientName: file.originalname
          size: file.size
          type: file.mimetype
          extension: file.extension
          url: url
          path: file.path

        res.imageData = image

        Image.update query, image, upsert: true, (err) ->
          logger.log 'warn', 'could not save image', 'Uploader' if err?

    return @multer
