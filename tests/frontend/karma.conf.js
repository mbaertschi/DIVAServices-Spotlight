module.exports = function(config){
  config.set({

    // Base path, that will be used to resolve all relative paths defined in files and exclude.
    basePath : '../..',

    // Hostname to be used when capturing browsers
    hostname: 'localhost',

    // The port where the web server will be listening
    port: '3001',

    // List of files/patterns to load in the browser
    files : [
      './web/bower_components/angular/angular.js',
      './web/bower_components/angular-ui-router/release/angular-ui-router.js',
      './web/bower_components/angular-mocks/angular-mocks.js',
      './web/app/modules/docs/module.coffee',
      './web/app/modules/docs/controllers/DocsPageController.coffee',
      './web/app/modules/dashboard/module.coffee',
      './web/app/modules/dashboard/controllers/DashboardPageController.coffee',
      './tests/frontend/unit/specs/**/*.coffee'
    ],

    // List of files/patterns to exclude from loaded files
    exclude: [
      './web/app/application.coffee'
    ],

    // Enable or disable watching files and executing the tests whenever one of these files changes
    autoWatch : false,

    // List of test frameworks you want to use
    frameworks: ['jasmine'],

    // List of browsers to launch and capture
    browsers : ['Chrome'],

    // We need to compile to js first
    preprocessors: {
      '**/*.coffee': ['coffee']
    },

    coffeePreprocessor: {
      options: {
        bare: false
      }
    },

    // If true, Karma will start and capture all configured browsers, run tests and then exit with an
    // exit code of 0 or 1 depending on whether all tests passed or any tests failed
    singleRun: true,

    reporters: ['progress', 'junit'],

    junitReporter : {
      outputFile: './tests/frontend/unit/results.xml',
      suite: 'unit'
    }

  });
};
