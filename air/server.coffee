express = require("express")
http    = require("http")
sysPath = require("path")
slashes = require("connect-slashes")

startServer = (port, path, callback) ->
  app = express()

  # Route all static files to http paths.
  app.use "", express.static(sysPath.resolve(path))

  # Redirect requests that include a trailing slash.
  app.use slashes(false)

  # Route all non-existent files to `index.html`
  app.all "*", (req, resp) ->
    resp.sendfile sysPath.join(path, "index.html")

  # Wrap express app with node.js server in order to have stuff like server.stop() etc.
  server = http.createServer(app)
  server.timeout = 2000

  server.listen port, callback

module.exports.startServer = startServer
