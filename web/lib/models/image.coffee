mongoose    = require 'mongoose'

ImageSchema = mongoose.Schema
  sessionId: String
  index: Number
  serverName: String
  clientName: String
  size: String
  type: String
  extension: String
  url: String
  path: String
  thumbUrl: String
  thumbPath: String

ImageSchema.index sessionId: 1

module.exports = mongoose.model 'Image', ImageSchema
