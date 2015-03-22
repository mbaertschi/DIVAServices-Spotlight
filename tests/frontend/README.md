Automated Frontend Test
=======================

This will run both, the unit tests and the e2e tests with karma, jasmine, and protractor

## Install dependencies

Assuming you have Chrome installed and won't use the Selenium server.

```bash
cd test/frontend
npm install
npm install karma-cli -g
```

## Run tests manually

Assuming you are in the root folder of the project and you have `foreman` installed.

```bash
nf -j Procfile.test start         # npm -g install foreman
```

```bash
cd test/frontend
npm run e2e
npm run unit
```

## Rung all tests at once

Assuming you are in the root folder of the project and you have `foreman` installed.

```bash
./scripts/run-tests
```

## Configuration documentation

* [Karma](http://karma-runner.github.io/0.12/config/configuration-file.html)
* [Protractor](https://github.com/angular/protractor/blob/master/docs/referenceConf.js)
