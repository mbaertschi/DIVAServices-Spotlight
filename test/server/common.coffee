nconf     = require '../../web/node_modules/nconf/lib/nconf'
nconf.add 'server', type: 'file', file: './web/conf/server.test.json'
nconf.add 'client', type: 'file', file: './web/conf/client.dev.json'
nconf.add 'schemas', type: 'file', file: './web/conf/schemas.json'

mongoose  = require '../../web/node_modules/mongoose'

before (done) ->

  require '../../web/lib/models/algorithm'
  require '../../web/lib/models/host'
  require '../../web/lib/models/image'

  clearDB = (callback) ->
    for i of mongoose.connection.collections
      mongoose.connection.collections[i].remove ->
    callback()

  if mongoose.connection.readyState is 0
    mongoose.connect 'mongodb://' + nconf.get('mongoDB:url'), (err) ->
      if err
        throw err
      clearDB ->
        mongoose.disconnect()
        done()
  else
    clearDB ->
      mongoose.disconnect()
      done()

after (done) ->
  mongoose.disconnect()
  done()
