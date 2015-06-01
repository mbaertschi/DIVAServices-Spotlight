Poller      = require '../../web/lib/poller'
should      = require('chai').should()
nconf       = require '../../web/node_modules/nconf/lib/nconf'
Mongo       = require '../../web/lib/mongo'
mongoose    = require '../../web/node_modules/mongoose'

hosts       = null
algorithms  = null


describe 'poller instance', ->

  before ->
    @mongo = new Mongo
    @poller = new Poller @mongo
    @Algorithm = mongoose.model 'Algorithm'
    @Host = mongoose.model 'Host'

  after ->
    mongoose.disconnect()

  it 'should initially have no algorithms in mongodb', (done) ->
    @Algorithm.find {}, (err, results) ->
      should.not.exist err
      results.should.have.length 0
      done()

  it 'should successfully add the dummy backend host', (done) ->
    host = new @Host
      host: 'Dummy Backend Host'
      url: 'http://localhost:8081'
    host.save done

  it 'should successfully load the dummy backend host', (done) ->
    @poller._loadHosts (err, results) ->
      should.not.exist err
      results.should.have.length 1
      results[0].host.should.equal 'Dummy Backend Host'
      hosts = results
      done()

  it 'should successfully load all algorithms', (done) ->
    @poller._loadAlgorithms hosts, (err, results) ->
      should.not.exist err
      results.should.have.length 5
      algorithms = results
      done()

  it 'should successfully add all five algorithms', (done) ->
    @poller._compareAndStoreAlgorithms algorithms, (err, algorithms, changedAlgorithms, addedAlgorithms) ->
      should.not.exist err
      algorithms.should.have.length 5
      changedAlgorithms.should.have.length 0
      addedAlgorithms.should.have.length 5
      done()

  it 'should detect changed algorithms', (done) ->
    @Algorithm.findOne (err, result) =>
      should.not.exist err
      result.description = 'new description'
      result.save (err, result) =>
        should.not.exist err
        result.description.should.equal 'new description'
        @poller._compareAndStoreAlgorithms algorithms, (err, algorithms, changedAlgorithms, addedAlgorithms) ->
          should.not.exist err
          algorithms.should.have.length 5
          changedAlgorithms.should.have.length 1
          addedAlgorithms.should.have.length 0
          done()

  it 'should detect removed algorithms', (done) ->
    algorithm = new @Algorithm
        name: 'test'
        description: 'test'
        url: 'http://localhost:8081/test'
        host: 'Dummy Backend Host'
    algorithm.save (err, result) =>
      should.not.exist err
      result.name.should.equal 'test'
      @poller._removeInvalidAlgorithms algorithms, (err, results) ->
        should.not.exist err
        results.should.have.length 1
        results[0].name.should.equal 'test'
        done()

  it 'should successfully poll all algorithms for dummy host', (done) ->
    @Algorithm.remove {}, (err, res) =>
      should.not.exist err
      res.result.ok.should.equal 1
      res.result.n.should.equal 5
      @poller._nextIteration =>
        @Algorithm.find {}, (err, results) ->
          should.not.exist err
          results.should.have.length 5
          done()
