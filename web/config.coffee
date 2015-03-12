exports.config =
  # See docs at https://github.com/brunch/brunch/blob/stable/docs/config.md

  # Not required for angular
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
          'app/**/module.coffee'
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

  server:
    path: 'server.coffee'
    port: 3000
