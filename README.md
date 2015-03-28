# DIA-Distributed

Unified repository for both, dummy rest server and client components for the DIA-Distributed project

## Installation

  1. Checkout the repository
  2. Install the mandatory dependencies:
    * [Node.js](https://nodejs.org/)
    * [npm](https://www.npmjs.com/)
    * [CoffeeScript](http://coffeescript.org/) ``npm install -g coffee-script``
    * [Brunch](http://brunch.io/) ``npm install -g brunch``
    * [Bower](http://bower.io/) ``npm install -g bower``
    * [Node Foreman](https://github.com/strongloop/node-foreman) ``npm install -g  foreman``
    * [PM2](https://github.com/Unitech/pm2) ``npm install -g pm2``
    * [karma-cli](https://www.npmjs.com/package/karma-cli) ``npm install -g karma-cli``
  3. Change to the ``rest`` directory and let NPM install the necessary libraries:
    ```bash
    cd rest
    npm install
    ```
  4. Change to the ``web`` directory and install the required Node.JS modules:
    ```bash
    cd web
    npm install
    bower install
    ```
  5. Change to the ``tests`` directory and install the required Node.js modules:
  ```bash
  cd tests/frontend
  npm install
  ```

## Environments
The DIA-Distributed application can be started within two environments.
  1. Developing mode
  ```bash
  export NODE_ENV=dev
  ```
  This configuration is recommended if you want to develop. It is also mandatory for running the tests.
  2. Production mode
  ```bash
  export NODE_ENV=prod
  ```
  This configuration is used for production. (Not yet implemented)

## Tests
Assuming you are in the root folder. Execute the following scripts:
```bash
./scripts/run-tests (runs all the tests)
./scripts/run-e2e-tests (runs the e2e tests with protractor)
./scripts/run-unit-tests (runs the karma-jasmine unit tests)
```
If you want to run the tests with npm:
1. e2e
```bash
cd /
nf -j Procfile.test start
cd tests/frontend
npm run e2e
```
2. unit
```bash
cd /tests/frontend
npm run unit
```

## Developing

To start and stop dummy rest server and web client with one command:

```bash
nf start

Exiting foreman does not stop the pm2 process. Use pm2 delete [id] to stop backend server
```

For manually starting backend server

```bash
cd /rest
pm2 start ./processes.dev.json
```

For manually starting web client

```bash
cd web
brunch w -s
```

Then go to [localhost:3000](http://localhost:3000)

## Production

Coming soon
