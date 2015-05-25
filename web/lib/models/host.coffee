# Host
# =========
#
# **Host** is the mongoose model for the host schema.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
mongoose    = require 'mongoose'

# `Host` schema definition
HostSchema = mongoose.Schema
  host: String
  url: String

# Expose `Host` schema
module.exports = mongoose.model 'Host', HostSchema
