# Config
# ======
#
# **Config** is the configuration file for [Brunch](http://brunch.io/).
# See docs at `https://github.com/brunch/brunch/blob/stable/docs/config.md`
#
# Copyright &copy; Michael Bärtschi, MIT Licensed.

# Expose brunch settings
brunchSettings = exports = module.exports = {}

# Brunch configurations
brunchSettings.config =

  modules:
    definition: false
    wrapper: false

  sourceMaps: true

  files:

    javascripts:
      defaultExtension: 'coffee'
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(vendor|bower_components)/
      order:
        before: [
          'app/**/*module.coffee'
          'app/**/*config.coffee'
        ]
        after: [
          'vendor/plugins/datatables-colvis/js/dataTables.colVis.js'
          'vendor/plugins/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.js'
          'vendor/plugins/datatables-tabletools/js/dataTables.tableTools.js'
          'vendor/plugins/datatables-responsive/files/1.10/js/datatables.responsive.js'
        ]

    stylesheets:
      defaultExtension: 'less'
      joinTo:
        'stylesheets/app.css' : /^app/
        'stylesheets/vendor.css' : /^(vendor|bower_components)/
      order:
        before: [
          'vendor/styles/bootstrap.less'
          'vendor/styles/smartadmin.less'
        ]

    templates:
      defaultExtension: 'hbs'
      joinTo: 'javascripts/app.js'

  conventions:

    ignored: /^(vendor\/styles\/smartadmin\/)/

  plugins:

    coffeelint:
      pattern: /^app\/.*\.coffee$/
      options:
        max_line_length:
          level: "ignore"
        indentation:
          value: 2
          level: "error"

    jaded:
      staticPatterns: /^app\/(.+)\.jade$/
      jade:
        pretty: yes

    uglify:
      mangle: false
      compress:
        global_defs:
          DEBUG: false

  server:
    path: 'server.coffee'
    port: 3000
