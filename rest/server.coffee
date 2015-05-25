# Dummy Backend Server
# =====================

# **Dummy Backend Server** is used for developing and testing. You can also use it as an API reference.
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Module dependencies
express     = require 'express'
http        = require 'http'
sysPath     = require 'path'
bodyParser  = require 'body-parser'
fs          = require 'fs-extra'

# Creates ``./images`` folder or empties it if it exists
fs.emptyDirSync './images'

# Seconds to wait before server sends response. ``SERVER_TIMEOUT`` must
# be smaller or equal to the server timeout specified in ``./web/conf/server.[dev/prod].json``
SERVER_TIMEOUT = 1

# Create server with [Express](http://expressjs.com/) web framework
app = express()

# Enable body parser for json content. ``limit`` must not be larger than specified in
# ``./web/conf/server.[dev/prod].json``
app.use bodyParser.json limit: '10mb'

# Root entry of REST server
# -------------------------
# Must respond with an ``array`` of ``objects`` whereas each object must
# meet the following [JSON Schema](http://json-schema.org/).
# ```
# "algorithmSchema": {
#   "id": "algorithmSchema",
#   "$schema": "http://json-schema.org/schema#",
#   "description": "schema for an algorithm overview entry",
#   "type": "object",
#   "required": ["name", "description", "url"],
#   "properties": {
#     "name": {
#       "type": "string",
#       "minLength": 2,
#       "maxLength": 50
#     },
#     "description": {
#       "type": "string",
#       "minLength": 5,
#       "maxLength": 255
#     },
#     "url": {
#       "format": "uri"
#     }
#   },
#   "additionalProperties": false
# }
# ```
# ---
# **app.get** `/`</br>
# Each entry will appear on the algorithms overview page. ``url`` must point to the
# algorithm uri. The response JSON file will be validated against the JSON-Schema
# described above. If any errors occure the involved algorithm will be skipped and
# be not available on the frontend.
app.get '/', (req, res) ->
  records = [
    {
      name: 'histogramenhancement'
      description: 'this will apply the histogramenhancement algorithm on your image. lets make a damn long description to test bootstrap behaviour'
      url: 'http://localhost:8081/histogramenhancement'
    }
    {
      name: 'multiscaleipd'
      description: 'this will apply the multiscaleipd algorithm on your image'
      url: 'http://localhost:8081/multiscaleipd'
    }
    {
      name: 'noise'
      description: 'this will apply the noise algorithm on your image'
      url: 'http://localhost:8081/noise'
    }
    {
      name: 'otsubinazrization'
      description: 'this will apply the otsubinazrization algorithm on your image'
      url: 'http://localhost:8081/otsubinazrization'
    }
    {
      name: 'sauvalabinarization'
      description: 'this will apply the sauvalabinarization algorithm on your image'
      url: 'http://localhost:8081/sauvalabinarization'
    }
  ]

  res.send records


# GET / POST routes for each algorithm
# ------------------------------------
#
# Each algorithm must provide a get and a post route. Calling get will return detailed
# information about that algorithm and also what kind of inputs it expects. The response
# must meet the following JSON-Schema.
# ```
# "algorithmSchema": {
#   "id": "algorithmSchema",
#   "$schema": "http://json-schema.org/schema#",
#   "description": "schema for an algorithm details view entry",
#   "definitions": {
#     "name": {
#       "type": "string",
#       "minLength": 3,
#       "maxLength": 25
#     },
#     "highlighter": {
#       "enum": ["polygon", "rectangle"]
#     },
#     "description": {
#       "type": "string",
#       "minLength": 3,
#       "maxLength": 255
#     },
#     "number": {
#       "type": "object",
#       "required": ["name", "options"],
#       "properties": {
#         "name": {
#           "$ref": "#/definitions/name"
#         },
#         "description": {
#           "$ref": "#/definitions/description"
#         },
#         "options": {
#           "type": "object",
#           "required": ["required", "default"],
#           "properties": {
#             "required": {
#               "type": "boolean"
#             },
#             "default": {
#               "type": "number"
#             },
#             "min": {
#               "type": "number"
#             },
#             "max": {
#               "type": "number"
#             },
#             "steps": {
#               "type": "number"
#             }
#           },
#           "additionalProperties": false
#         }
#       },
#       "additionalProperties": false
#     },
#     "text": {
#       "type": "object",
#       "required": ["name", "options"],
#       "properties": {
#         "name": {
#           "$ref": "#/definitions/name"
#         },
#         "description": {
#           "$ref": "#/definitions/description"
#         },
#         "options": {
#           "type": "object",
#           "required": ["required", "default"],
#           "properties": {
#             "required": {
#               "type": "boolean"
#             },
#             "default": {
#               "type": "string"
#             },
#             "min": {
#               "type": "number"
#             },
#             "max": {
#               "type": "number"
#             }
#           },
#           "additionalProperties": false
#         }
#       },
#       "additionalProperties": false
#     },
#     "select": {
#       "type": "object",
#       "required": ["name", "options"],
#       "properties": {
#         "name": {
#           "$ref": "#/definitions/name"
#         },
#         "description": {
#           "$ref": "#/definitions/description"
#         },
#         "options": {
#           "type": "object",
#           "required": ["required", "values", "default"],
#           "properties": {
#             "required": {
#               "type": "boolean"
#             },
#             "values": {
#               "type": "array",
#               "minItems": 1,
#               "uniqueItems": true,
#               "items": {
#                 "type": "string"
#               },
#               "additionalItems": false
#             },
#             "default": {
#               "type": "number"
#             }
#           },
#           "additionalProperties": false
#         }
#       },
#       "additionalProperties": false
#     },
#     "checkbox": {
#       "type": "object",
#       "required": ["name", "options"],
#       "properties": {
#         "name": {
#           "$ref": "#/definitions/name"
#         },
#         "description": {
#           "$ref": "#/definitions/description"
#         },
#         "options": {
#           "type": "object",
#           "required": ["required", "default"],
#           "properties": {
#             "required": {
#               "type": "boolean"
#             },
#             "default": {
#               "type": "number"
#             }
#           },
#           "additionalProperties": false
#         }
#       },
#       "additionalProperties": false
#     }
#   },
#   "type": "object",
#   "required": ["name", "description", "url", "input"],
#   "properties": {
#     "name": {
#       "type": "string",
#       "minLength": 2,
#       "maxLength": 50
#     },
#     "description": {
#       "type": "string",
#       "minLength": 5
#     },
#     "url": {
#       "format": "uri"
#     },
#     "input": {
#       "type": "array",
#       "items": {
#         "description": "Input types",
#         "type": "object",
#         "properties": {
#           "highlighter": {
#             "$ref": "#/definitions/highlighter"
#           },
#           "number": {
#             "$ref": "#/definitions/number"
#           },
#           "text": {
#             "$ref": "#/definitions/text"
#           },
#           "select": {
#             "$ref": "#/definitions/select"
#           },
#           "checkbox": {
#             "$ref": "#/definitions/checkbox"
#           }
#         },
#         "additionalProperties": false
#       },
#       "additionalItems": false
#     }
#   },
#   "additionalProperties": false
# }
# ```
#
# Call the post route of an algorithm to use it. The request's body must contain the
# information which was provided by the get route and also the image to apply the
# algorithm on. The response of the post route must meet the following JSON-Schema.
# ```
# "responseSchema": {
#   "id": "responseSchema",
#   "$schema": "http://json-schema.org/schema#",
#   "description": "schema for response entry",
#   "definitions":  {
#     "segment": {
#       "type": "array",
#       "minItems": 1,
#       "items": {
#         "type": "array",
#         "minItems": 2,
#         "maxItems": 2,
#         "items": {
#           "type": "number"
#         }
#       }
#     }
#   },
#   "type": "object",
#   "properties": {
#     "output": {
#       "type": "object"
#     },
#     "image": {
#       "type": "string"
#     },
#     "highlighters": {
#       "type": "array",
#       "minItems": 1,
#       "items": {
#         "description": "Segments",
#         "type": "object",
#         "required": ["segments"],
#         "properties": {
#           "segments": {
#             "$ref": "#/definitions/segment"
#           }
#         },
#         "additionalProperties": false
#       }
#     }
#   },
#   "additionalProperties": false
# }
# ```

# ``GET`` route for ``histogramenhancement`` algorithm
app.get '/histogramenhancement', (req, res) ->
  records =
    name: 'histogramenhancement'
    description: 'this will apply the histogramenhancement algorithm on your image. this is just a placeholder. this is just a placeholder.. this is just a placeholder.. this is just a placeholder.. this is just a placeholder.. this is just a placeholder.'
    url: 'http://localhost:8081/histogramenhancement'
    input: [
      {
        highlighter: 'rectangle'
      }
    ]

  res.send records

# ``POST`` route for ``histogramenhancement`` algorithm
app.post '/histogramenhancement', (req, res) ->
  base64image = req.body.image
  decodedImage = new Buffer(base64image, 'base64')
  fs.writeFile './images/histogramenhancement.png', decodedImage, (err) ->
    console.log err if err?

    result =
      output:
        field1: 'information field1'
        field2: 'information field2'
        field3: 4

    fs.readFile './test.png', (err, img) ->
      if not err?
        result.image = img.toString('base64')
      random = Math.floor Math.random() * SERVER_TIMEOUT + 1
      setTimeout (-> res.send result), random * 1000


# ``GET`` route for ``multiscaleipd`` algorithm
app.get '/multiscaleipd', (req, res) ->
  records =
    name: 'multiscaleipd'
    description: 'this will apply the multiscaleipd algorithm on your image'
    url: 'http://localhost:8081/multiscaleipd'
    input: [
      {
        highlighter: 'polygon'
      }
      {
        select:
          name: 'detector'
          description: 'this is just a test description for a select'
          options:
            required: true
            values: [
              'Harris'
              'Narris'
            ]
            default: 0
      }
      {
        number:
          name: 'blurSigma'
          description: 'this is just a test description for blugSigma'
          options:
            required: true
            min: 0
            max: 5
            steps: 1
            default: 2
      }
      {
        number:
          name: 'numScales'
          options:
            required: true
            default: 1
      }
      {
        number:
          name: 'numOctaves'
          options:
            required: true
            default: 2
      }
      {
        number:
          name: 'threshold'
          options:
            required: false
            steps: 0.000001
            default: 0.000001
      }
      {
        number:
          name: 'maxFeaturesPerScale'
          options:
            required: true
            default: 3
      }
      {
        text:
          name: 'textInputTest'
          description: 'this is just a test description for a text input'
          options:
            required: true
            min: 3
            max: 10
            default: 'test text'
      }
      {
        checkbox:
          name: 'testCheckbox'
          description: 'this is just a test description for a checkbox'
          options:
            required: true
            default: 1
      }
    ]

  res.send records

# ``POST`` route for ``multiscaleipd`` algorithm
app.post '/multiscaleipd', (req, res) ->
  base64image = req.body.image
  decodedImage = new Buffer(base64image, 'base64')
  fs.writeFile './images/multiscaleipd.png', decodedImage, (err) ->
    console.log err if err?

    result =
      output:
        field1: 'information field1'
        field2: 'information field2'
        field3: 4
      highlighters: [
        {
          segments: [
            [100, 100]
            [150, 100]
            [150, 150]
            [100, 150]
          ]
        }
        {
          segments: [
            [200, 200]
            [250, 200]
            [250, 250]
            [200, 250]
          ]
        }
      ]

    random = Math.floor Math.random() * SERVER_TIMEOUT + 1
    setTimeout (-> res.send result), random * 1000


# ``GET`` route for ``noise`` algorithm
app.get '/noise', (req, res) ->
  records =
    name: 'noise'
    description: 'this will apply the noise algorithm on your image'
    url: 'http://localhost:8081/noise'
    input: [
      {
        highlighter: 'rectangle'
      }
    ]

  res.send records

# ``POST`` route for ``noise`` algorithm
app.post '/noise', (req, res) ->
  base64image = req.body.image
  decodedImage = new Buffer(base64image, 'base64')
  fs.writeFile './images/noise.png', decodedImage, (err) ->
    console.log err if err?

    result =
      output:
        field1: 'information field1'
        field2: 'information field2'
        field3: 4

    random = Math.floor Math.random() * SERVER_TIMEOUT + 1
    setTimeout (-> res.send result), random * 1000


# ``GET`` route for ``otsubinazrization`` algorithm
app.get '/otsubinazrization', (req, res) ->
  records =
    name: 'otsubinazrization'
    description: 'this will apply the otsubinazrization algorithm on your image'
    url: 'http://localhost:8081/otsubinazrization'
    input: []

  res.send records

# ``POST`` route for ``otsubinazrization`` algorithm
app.post '/otsubinazrization', (req, res) ->
  return res.status(400).json error: 'no image provided' if not req.body.image?
  base64image = req.body.image
  decodedImage = new Buffer(base64image, 'base64')
  fs.writeFile './images/otsubinazrization.png', decodedImage, (err) ->
    console.log err if err?

    result =
      output:
        field1: 'information field1'
        field2: 'information field2'
        field3: 4
      highlighters: [
        {
          segments: [
            [100, 100]
            [150, 100]
            [150, 150]
            [100, 150]
          ]
        }
        {
          segments: [
            [200, 200]
            [250, 200]
            [250, 250]
            [200, 250]
          ]
        }
      ]

    fs.readFile './test.png', (err, img) ->
      if not err?
        result.image = img.toString('base64')
      random = Math.floor Math.random() * SERVER_TIMEOUT + 1
      setTimeout (-> res.send result), random * 1000


# ``GET`` route for ``sauvalabinarization`` algorithm
app.get '/sauvalabinarization', (req, res) ->
  records =
    name: 'sauvalabinarization'
    description: 'this will apply the sauvalabinarization algorithm on your image'
    url: 'http://localhost:8081/sauvalabinarization'
    input: []

  res.send records

# ``POST`` route for ``sauvalabinarization`` algorithm
app.post '/sauvalabinarization', (req, res) ->
  base64image = req.body.image
  decodedImage = new Buffer(base64image, 'base64')
  fs.writeFile './images/sauvalabinarization.png', decodedImage, (err) ->
    console.log err if err?

    result = {}

    random = Math.floor Math.random() * SERVER_TIMEOUT + 1
    setTimeout (-> res.send result), random * 1000

app.use (err, req, res, next) ->
  res.status err.status or 500
  res.json err.statusText


# Wrap express app with node.js server in order to have stuff like server.stop() etc.
server = http.createServer(app)
server.timeout = 12000

# Start server on port 8081
server.listen 8081, ->
  console.log 'Server listening on port 8081'
