Automated Frontend Test
=======================

This will run both, the unit tests and the e2e tests with karma, jasmine, and protractor

## Install Dependencies

Assuming you have Chrome installed and won't use the Selenium server.

```bash
cd test/frontend
npm install
```

## Run Testserver

Assuming you are in the root folder of the project and you have `foreman` installed.

```bash
nf -j Procfile.test start         # npm -g install foreman
```

## Run Tests

```bash
cd test/frontend
npm test
```
