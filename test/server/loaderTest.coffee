loader      = require '../../web/lib/loader'
should      = require('chai').should()
nconf       = require '../../web/node_modules/nconf/lib/nconf'
fs          = require 'fs'
path        = require 'path'

describe 'loader instance', ->

  before (done) ->
    @body = {}
    dir = path.resolve(__dirname, '../test.png')
    fs.readFile dir, (err, img) =>
      @body.image = img.toString('base64')
      done()

  it 'should successfully load an algorithm from dummy backend host', (done) ->
    settings =
      options: url: 'http://localhost:8081/histogramenhancement'
    loader.get settings, (err, result) ->
      should.not.exist err
      algorithm = JSON.parse result
      algorithm.name.should.equal 'histogramenhancement'
      done()

  it 'should successfully post an algorithm to dummy backend host', (done) ->
    settings =
      options: url: 'http://localhost:8081/multiscaleipd'
    loader.post settings, @body, (err, result) ->
      should.not.exist err
      result.output.field1.should.equal 'information field1'
      result.highlighters.should.have.length 1
      done()
