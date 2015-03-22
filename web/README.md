#DIA-Distributed Web App

Web frontend (single page) for DIA-Distributed project

Getting started
---------------

###Requirements:
You need to have `npm` installed.

Install `brunch`, `coffee-script`, and `foreman`

```bash
npm -g install bower
npm -g install foreman
npm -g install brunch
npm -g install coffee-script
```

###Install dependencies:
Assuming you are in the web folder and `npm` is installed.
```bash
npm install
```

###Install JS components:
Assuming you are in the web folder and `npm` is installed.
```bash
bower install
```

###Starting the application
Assuming you are in the root folder of the application.
```bash
export NODE_ENV=dev
nf start
```

Then goto [http://localhost:3000](http://localhost:3000)
