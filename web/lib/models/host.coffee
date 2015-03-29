mongoose    = require 'mongoose'

HostSchema = mongoose.Schema
  host: String
  url: String

module.exports = mongoose.model 'Host', HostSchema
