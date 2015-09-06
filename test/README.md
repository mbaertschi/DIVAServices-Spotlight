Automated Testing
=======================

This will run the e2e tests with protractor and the server tests with mocha

## Install dependencies

```bash
$ cd test
$ npm install
```

## Run tests manually

### server tests
Assuming you are in the root folder of the project and you have `foreman` installed.

```bash
Shell 1
$ coffee rest/server.coffee
```

```bash
Shell 2
$ ./test/node_modules/.bin/mocha
```
### e2e tests

Assuming you are in the root folder of the project and you have `foreman` installed.

```bash
Shell 1
$ nf -j Procfile.dev -e etc/test.env start
```

```bash
Shell 2
$ cd test
$ npm run e2e
```

## Run all tests at once

Assuming you are in the root folder of the project and you have `foreman` installed.

```bash
$ ./scripts/run-tests
```

## Configuration documentation

* [Protractor](https://github.com/angular/protractor/blob/master/docs/referenceConf.js)
* [Mocha](http://mochajs.org/)
