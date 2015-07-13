# Utils
# =====
#
# **Utils** encapsulates all methods used for image manipulation.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
fs        = require 'fs-extra'
logger    = require '../lib/logger'
gm        = require 'gm'

# We don't want images to be larger than 1024 pixels with / height
MAX_SIZE = 4000

# Expose utils
utils = exports = module.exports = {}

# ---
# **utils.getFilesizeInBytes**</br>
# Read an image from disk and return its file size</br>
# `params:`
#   * *filename* `<String>` path to image location
utils.getFilesizeInBytes = (filename) ->
  stats = fs.statSync(filename)
  fileSizeInBytes = stats['size']
  fileSizeInBytes

# ---
# **utils.writeImage**</br>
# Write a base64 encoded image to disk and callback its file size</br>
# `params:`
#   * *image* `<Object>` image object from mongoDB
#   * *file* `<String>` base64 encoded image
utils.writeImage = (image, file, callback) ->
  matches = file.match(/^data:([A-Za-z-+\/]+);base64,(.+)$/)
  imageBuffer = {}

  if (matches.length isnt 3)
    logger.log 'warn', 'invalid input string for image', 'Utils'
    callback 'Invalid input string'
  else
    imageBuffer.type = matches[1];
    imageBuffer.data = new Buffer(matches[2], 'base64');

    fs.ensureDirSync 'public/uploads/' + image.sessionId

    fs.writeFile image.path, imageBuffer.data, (err) ->
      if err?
        logger.log 'warn', 'there was an error while storing one of the images', 'Utils'
        callback err
      else
        callback null, utils.getFilesizeInBytes(image.path)

# ---
# **utils.getImageSize**</br>
# Load image from disk and return its size (width and height in pixels)</br>
# `params:`
#   * image `<Object>` image object from mongoDB
utils.getImageSize = (image, callback) ->
  gm(image.path).size (err, size) ->
    if err? then logger.log 'warn', "gm could not load image size error=#{err}", 'Utils'
    callback err, size.width, size.height

# ---
# **utils.processImage**</br>
# Resize, auto orient, remove exif-metadata, and write image to disk</br>
# `params:`
#   * image `<Object>` image object from mongoDB
utils.processImage = (image, callback) ->
  utils.getImageSize image, (err, width, height) ->
    if err?
      callback()
    else
      if width > height
        if width > MAX_SIZE
          originWidth = width
          width = MAX_SIZE
          height = height * (width/originWidth)
      else
        if height > MAX_SIZE
          originHeight = height
          height = MAX_SIZE
          width = width * (height/originHeight)
      gm(image.path).resize(width, height).autoOrient().noProfile().write image.path, (err) ->
        if err? then logger.log 'warn', "gm could not resize and orientate image error=#{err}", 'Utils'
        callback()

# ---
# **utils.convertToPng**</br>
# Convert an image to .png if not yet so. Callback updated image object to store in mongoDB</br>
# `params:`
#   * image `<Object>` image object from mongoDB
utils.convertToPng = (image, callback) ->
  if image.type isnt 'image/png'
    name = image.serverName.split('.')[0] + '.png'
    path = image.path.replace image.serverName, name
    gm(image.path).write path, (err) ->
      if err?
        logger.log 'warn', "gm could convert image=#{image.serverName} error=#{err}", 'Utils'
        callback null, image
      else
        fs.removeSync image.path
        serverName = image.serverName
        image.serverName = name
        image.clientName = image.clientName.split('.')[0] + '.png'
        image.type = 'image/png'
        image.extension = 'png'
        image.url = image.url.replace serverName, name
        image.path = path
        callback null, image
  else
    callback null, image

# ---
# **utils.createThumbnail**</br>
# Create a thumbnail for the given image. Callback its path and url to store in mongoDB</br>
# `params:`
#   * image `<Object>` image object from mongoDB
utils.createThumbnail = (image, callback) ->
  thumbSize = 160
  imageName = image.serverName.split('.' + image.extension)[0]
  thumbName = imageName + '_thumbnail.' + image.extension
  thumbPath = image.path.replace image.serverName, thumbName
  thumbUrl = image.url.replace image.serverName, thumbName
  gm(image.path).resize(thumbSize, thumbSize, '^').gravity('Center').extent(thumbSize, thumbSize).write thumbPath, (err) ->
    if err?
      logger.log 'trace', "gm could not create thumbnail for image=#{image.serverName} error=#{err}", 'Utils'
      thumbPath = image.path
      thumbUrl = image.url
    callback null, thumbPath, thumbUrl
