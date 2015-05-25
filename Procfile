#
# Configuration file for forman. Simplifies development
# by starting all required processes at once.
#
# Node version:
#   > npm -g install foreman
#   > nf start
#

# start the mongo-express admin interface
#mongo: cd web && node ./node_modules/mongo-express/app.js

# start the backend server
api: cd rest && forever -m 5 --minUptime 1000 --spinSleepTime 5000 -c coffee server.coffee

# start the server
web: cd web && forever -m 5 --minUptime 1000 --spinSleepTime 5000 -c coffee server.coffee
