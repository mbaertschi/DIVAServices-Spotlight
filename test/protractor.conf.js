exports.config = {

  // Order is important. Always put images before algorithms and
  // algorithms before results
  specs: [
    './frontend/e2e/specs/dashboard.coffee',
    './frontend/e2e/specs/documents.coffee',
    './frontend/e2e/specs/images.coffee',
    './frontend/e2e/specs/algorithms.coffee',
    './frontend/e2e/specs/results.coffee'
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

    var consoleHelper = require('./frontend/e2e/helpers/console');
    afterEach(consoleHelper.expectEmptyConsole);
  },

  resultJsonOutputFile: './frontend/e2e/results.json'

};
