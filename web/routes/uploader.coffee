multer      = require 'multer'
fs          = require 'fs-extra'
nconf       = require 'nconf'
mongoose    = require 'mongoose'
logger      = require '../lib/logger'
util        = require 'util'

uploader = exports = module.exports = class Uploader

  constructor: ->
    @multer = multer
      dest: nconf.get 'web:uploader:destination'
      limits:
        fieldSize: 10 * 1024 * 1024
      rename: (fieldname, filename, req, res) ->
        name = 'upload_' + req.body.index
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
          index: req.body.index

        res.imageData = image

        Image.update query, image, upsert: true, (err) ->
          logger.log 'warn', 'could not save image', 'Uploader' if err?
          return

  multer: =>
    @multer
