# Utils
# =====
#
# **Utils** encapsulates all methods used for image manipulation.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
fs        = require 'fs-extra'
logger    = require '../lib/logger'
ExifImage = require('exif').ExifImage
lwip      = require 'lwip'

# We don't want images to be larger than 1024 pixels with / height
MAX_SIZE = 1024

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
# **utils.getRotation**</br>
# Read Exif meta-data from an image and callback rotation in degree</br>
# `params:`
#   * path `<String>` path to image location
utils.getRotation = (path, callback) ->
  try
    new ExifImage image: path, (err, exifData) ->
      if err
        callback "could not extract exif meta-data from image=#{path} error=#{err}"
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
    callback "could not load ExifImage on image=#{path} error=#{err}"

# ---
# **utils.orientateJpegImage**</br>
# Resize and rotate an image. Callback once you are done</br>
# `params:`
#   * image `<Object>` image object from mongoDB
utils.orientateJpegImage = (image, callback) ->
  path = image.path

  resizeAndRotate = (image, rotate) ->
    lwip.open path, (err, img) ->
      if err?
        logger.log 'info', "lwip could not load image=#{path} error=#{err}", 'Utils'
        callback()
      else
        width = img.width()
        height = img.height()
        if width > height
          if width > MAX_SIZE
            width = MAX_SIZE
            height = height * (width/img.width())
        else
          if height > MAX_SIZE
            height = MAX_SIZE
            width = width * (height/img.height())
        img.batch().resize(width, height).rotate(rotate).writeFile path, (err) ->
          if err then logger.log 'info', "lwip could not rotate image=#{path} error=#{err}", 'Utils'
          callback()

  if image.type is 'image/jpeg'
    utils.getRotation path, (err, rotate) ->
      if err?
        logger.log 'info', err, 'Utils'
        callback()
      else
        if rotate
          resizeAndRotate image, rotate, callback
        else
          resizeAndRotate image, 0, callback
  else
    resizeAndRotate image, 0, callback

# ---
# **utils.convertToPng**</br>
# Convert an image to .png if not yet so. Callback updated image object to store in mongoDB</br>
# `params:`
#   * image `<Object>` image object from mongoDB
utils.convertToPng = (image, callback) ->
  if image.type isnt 'image/png'
    lwip.open image.path, (err, img) ->
      if err?
        logger.log 'info', "lwip could not open image=#{image.serverName} error=#{err}", 'Utils'
        callback null, image
      else
        name = image.serverName.split('.')[0] + '.png'
        path = image.path.replace image.serverName, name
        img.writeFile path, 'png', (err) ->
          if err?
            logger.log 'info', "could not convert to png image=#{image.serverName} error=#{err}", 'Utils'
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
  lwip.open image.path, (err, img) ->
    if err?
      logger.log 'info', "lwip could not load image=#{image.serverName} error=#{err}", 'Utils'
      if image.thumbPath?
        callback null, image.thumbPath, image.thumbUrl
      else
        callback null, image.path, image.url
    else
      thumbSize = 160
      if img.width() < img.height()
        scale = (thumbSize / img.width())
      else
        scale = (thumbSize / img.height())
      imageName = image.serverName.split('.' + image.extension)[0]
      thumbName = imageName + '_thumbnail.' + image.extension
      thumbPath = image.path.replace image.serverName, thumbName
      thumbUrl = image.url.replace image.serverName, thumbName
      img.batch().scale(scale).crop(thumbSize, thumbSize).writeFile thumbPath, (err) ->
        if err?
          logger.log 'info', "lwip could not create thumbnail for image=#{image.serverName} error=#{err}", 'Utils'
          thumbPath = image.path
          thumbUrl = image.url
        callback null, thumbPath, thumbUrl
