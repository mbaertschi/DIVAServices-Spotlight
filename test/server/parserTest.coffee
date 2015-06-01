parser    = require '../../web/lib/parser'
should    = require('chai').should()
nconf     = require '../../web/node_modules/nconf/lib/nconf'

describe 'parser instance', ->

  it 'should return an error on invalid JSON formatted input', (done) ->
    parser.parseRoot "not valid json", (err, result) ->
      err.should.equal 'not a valid JSON format'
      done()

  it 'should return an error if input is not of type array', (done) ->
    structure = JSON.stringify {}
    parser.parseRoot structure, (err, result) ->
      err.should.equal 'is not of a type(s) array'
      done()

  it 'should allow empty array as input', (done) ->
    structure = JSON.stringify []
    parser.parseRoot structure, (err, result) ->
      should.not.exist err
      result.records.should.have.length 0
      done()

  it 'should skip algorithm when name is not defined', (done) ->
    structure = [
      {
        description: 'this will apply the histogramenhancement algorithm on your image. lets make a damn long description to test bootstrap behaviour'
        url: 'http://localhost:8081/histogramenhancement'
      }
    ]
    structure = JSON.stringify structure
    parser.parseRoot structure, (err, result) ->
      should.not.exist err
      result.records.should.have.length 0
      done()

  it 'should skip algorithm when description is not defined', (done) ->
    structure = [
      {
        name: 'histogramenhancement'
        url: 'http://localhost:8081/histogramenhancement'
      }
    ]
    structure = JSON.stringify structure
    parser.parseRoot structure, (err, result) ->
      should.not.exist err
      result.records.should.have.length 0
      done()

  it 'should skip algorithm when url is not defined', (done) ->
    structure = [
      {
        name: 'histogramenhancement'
        description: 'this will apply the histogramenhancement algorithm on your image. lets make a damn long description to test bootstrap behaviour'
      }
    ]
    structure = JSON.stringify structure
    parser.parseRoot structure, (err, result) ->
      should.not.exist err
      result.records.should.have.length 0
      done()

  it 'should skip algorithm when additional items are defined', (done) ->
    structure = [
      {
        name: 'histogramenhancement'
        description: 'this will apply the histogramenhancement algorithm on your image. lets make a damn long description to test bootstrap behaviour'
        url: 'http://localhost:8081/histogramenhancement'
        add: 'additional item'
      }
    ]
    structure = JSON.stringify structure
    parser.parseRoot structure, (err, result) ->
      should.not.exist err
      result.records.should.have.length 0
      done()

  it 'should return algorithm if it is correctly formatted', (done) ->
    structure = [
      {
        name: 'histogramenhancement'
        description: 'this will apply the histogramenhancement algorithm on your image. lets make a damn long description to test bootstrap behaviour'
        url: 'http://localhost:8081/histogramenhancement'
      }
    ]
    structure = JSON.stringify structure
    parser.parseRoot structure, (err, result) ->
      should.not.exist err
      result.records.should.have.length 1
      record = result.records[0]
      record.name.should.equal 'histogramenhancement'
      record.description.should.equal 'this will apply the histogramenhancement algorithm on your image. lets make a damn long description to test bootstrap behaviour'
      record.url.should.equal 'http://localhost:8081/histogramenhancement'
      done()
