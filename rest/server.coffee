express = require("express")
http    = require("http")
sysPath = require("path")

app = express()

# Root will respond with the REST url structure
app.get '/', (req, res) ->
  records =
    url1:
      name: 'Url 1'
      url: 'http://localhost:3333/url1'
    url2:
      name: 'Url 2'
      url: 'http://localhost:3333/url2'
  res.send records

app.get '/url1', (req, res) ->
  records =
    name: 'Url 1'
    description: 'Description for Url 1'
    methods: [
      get: 'returns this information'
      post: 'use this algorithm'
    ]
    inputOptions:
      option1: 'option1'
      option2: 'option2'
    outputOptions:
      option1: 'option1'
      option2: 'option2'

  res.send records

app.get '/url2', (req, res) ->
  records =
    name: 'Url 2'
    description: 'Description for Url 2'
    methods: [
      get: 'returns this information'
      post: 'use this algorithm'
    ]
    inputOptions:
      option1: 'option1'
      option2: 'option2'
    outputOptions:
      option1: 'option1'
      option2: 'option2'

  res.send records

app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: err
  return

# Wrap express app with node.js server in order to have stuff like server.stop() etc.
server = http.createServer(app)
server.timeout = 2000

server.listen 3333, ->
  console.log 'Server listening on port 3333'
