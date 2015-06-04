# DIA-Distributed

Unified repository for both, dummy rest server and client components for the DIA-Distributed project

## Installation

  1. Checkout the repository
  2. Install the mandatory dependencies:
    * [mongoDB](http://docs.mongodb.org/manual/installation/) and start mongo daemon
    * [Node.js](https://docs.npmjs.com/getting-started/installing-node) and update npm

    Following packages must be installed globally. If you use `install` script, you can omit this and all the following sections from *Install*.

    * [CoffeeScript](http://coffeescript.org/) ``npm install -g coffee-script``
    * [Brunch](http://brunch.io/) ``npm install -g brunch``
    * [Bower](http://bower.io/) ``npm install -g bower``
    * [Node Foreman](https://github.com/strongloop/node-foreman) ``npm install -g  foreman``
    * [forever](https://github.com/foreverjs/forever) ``npm install -g forever``

  3. Change to the ``rest`` directory and let NPM install the necessary libraries:

    ```bash
    $ cd rest
    $ npm install
    ```
  4. Change to the ``web`` directory and install the required Node.JS modules:

    ```bash
    $ cd web
    $ npm install
    $ bower install
    ```
  5. Change to the ``test`` directory and install the required Node.js modules:

    ```bash
    $ cd test
    $ npm install
    ```
  6. Create the folder logs under /web/
  7. Add dummy backend host to ``hosts`` collection in ``dia_dev`` database

    ```bash
    $ mongo
    > use dia_dev
    > db.hosts.insert({"host": "Dummy Backend Host", "url": "http://localhost:8081"})
    ```
  8. Configure mongo-express if you intend to use it. (Per default it is disabled. To enable it, uncomment line 6 in ``Procfile.dev``)

    Assuming you are in the root folder
    ```bash
    $ cd web/node_modules/mongo-express
    $ cp config.default.js config.js
    ```
    Then change the port on line 46 to ``8083``. If you have any authentication settings on your mongoDB, please configure the ``config.js`` file according to it.

## Environments
The DIA-Distributed application can be started within two environments.
  1. Developing mode

  ```bash
  $ export NODE_ENV=dev
  ```
  This configuration is recommended if you want to develop. It is also mandatory for running the tests.
  2. Production mode

  ```bash
  $ export NODE_ENV=prod
  ```
  This configuration is used for production.

## Tests
Assuming you are in the root folder. Execute the following scripts:
```bash
$ ./scripts/run-tests (runs all the tests)
```
If you want to run the tests manually:
  1. e2e

  In root folder:

  ```bash
  Shell 1
  $ nf -j Procfile.dev -e dev.env start

  Shell 2
  $ cd test
  $ npm run e2e
  ```

  2. server

  In root folder:

  ```bash
  Shell 1
  coffee rest/server.coffee

  Shell 2
  $ ./test/node_modules/.bin/mocha
  ```
  
## Developing

To start and stop dummy rest server and web client with one command:

```bash
$ nf -j Procfile.dev -e dev.env start
```

For manually starting backend server

```bash
$ cd rest
$ forever -m 5 --minUptime 1000 --spinSleepTime 5000 --watch -c coffee server.coffee
```

For manually starting web client

```bash
$ export NODE_ENV=dev
$ cd web
$ brunch w -s
```

Then go to [localhost:3000](http://localhost:3000)

## Production

To run DIA-Distributed in production mode follow those steps:

```bash
$ cd web && brunch b -P
$ cd ..
$ nf -e prod.env start
```
