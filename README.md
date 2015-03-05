A.I.-Revolution
===============

Unified repository for both, dummy rest server and client components for the A.I.-Revolution project

Installation
------------

  1. Checkout the repository
  1. Install the mandatory dependencies: Node.JS, NPM
  1. Change to the ``rest`` directory and let NPM install the necessary libraries:

    ```
    npm install
    ```

  1. Change to the ``web`` directory and install the required Node.JS modules:

    ```
    npm install -g brunch
    npm install

    npm install -g bower
    bower install
    ```

Developing
----------

To start and stop dummy rest server and web client with one command:

    npm -g install pm2
    nf start

    Exiting foreman does not stop the pm2 process. Use pm2 delete [id] to stop backend server

For manually starting backend server

    pm2 start ./config/processes.dev.json

For manually starting web client

    cd web
    brunch w -s
