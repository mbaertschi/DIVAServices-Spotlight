# Image
# =========
#
# **Image** is the mongoose model for the image schema.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
mongoose    = require 'mongoose'

# `Image` schema definition
ImageSchema = mongoose.Schema
  sessionId: String
  serverName: String
  clientName: String
  size: String
  type: String
  extension: String
  url: String
  path: String
  thumbUrl: String
  thumbPath: String

# Set the images sessionId as its index
ImageSchema.index sessionId: 1

# Expose 'Image' schema
module.exports = mongoose.model 'Image', ImageSchema
