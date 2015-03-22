exports.config = {

  specs: [
    './e2e/specs/**/*.coffee'
  ],

  // Start these browsers, currently available:
  // - chrome
  // - ChromeCanary
  // - Firefox
  // - Safari
  // - PhantomJS
  // - IE (only Windows)
  // - iOS (only Mac)
  multiCapabilities: [{
    'browserName': 'chrome'
  }],

  directConnect: true,

  baseUrl: 'http://localhost:3000/',

  framework: 'jasmine2',

  params: {
  },

  onPrepare: function() {

    // make sure page is loaded
    console.log('Loading root URL ...');
    browser.get('/');

    var consoleHelper = require('./e2e/helpers/console');
    afterEach(consoleHelper.expectEmptyConsole);
  },

  resultJsonOutputFile: './e2e/results.json'

};
