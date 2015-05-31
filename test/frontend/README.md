Automated Frontend Test
=======================

This will run the e2e tests with protractor

## Install dependencies

Assuming you have Chrome installed and won't use the Selenium server.

```bash
$ cd test/frontend
$ npm install
```

## Run tests manually

Assuming you are in the root folder of the project and you have `foreman` installed.

```bash
$ nf -j Procfile.dev -e dev.env start         # npm -g install foreman
```

```bash
$ cd test/frontend
$ npm run e2e
```

## Rung all tests at once

Assuming you are in the root folder of the project and you have `foreman` installed.

```bash
$ ./scripts/run-tests
```

## Configuration documentation

* [Protractor](https://github.com/angular/protractor/blob/master/docs/referenceConf.js)
