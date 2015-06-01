Pusher      = require '../../web/lib/pusher'
should      = require('chai').should()
nconf       = require '../../web/node_modules/nconf/lib/nconf'
io          = require('../../web/node_modules/socket.io').listen(5000)
ioClient    = require 'socket.io-client'

describe 'pusher instance', ->

  before (done) ->
    @pusher = new Pusher io
    socketURL = 'http://0.0.0.0:5000'
    options =
      transports: ['websocket']
      'force new connection': true
    @client = ioClient.connect socketURL, options
    @client.on 'connect', ->
      done()

  it 'should emit updated algorithms on the "update algorithms" channel', (done) ->
    @pusher.update 'updated algorithms'
    @client.on 'update algorithms', (message) ->
      message.should.equal 'updated algorithms'
      done()

  it 'should emit added algorithms on the "add algorithms" channel', (done) ->
    @pusher.add 'added algorithms'
    @client.on 'add algorithms', (message) ->
      message.should.equal 'added algorithms'
      done()

  it 'should emit removed algorithms on the "delete algorithms" channel', (done) ->
    @pusher.delete 'removed algorithms'
    @client.on 'delete algorithms', (message) ->
      message.should.equal 'removed algorithms'
      done()
