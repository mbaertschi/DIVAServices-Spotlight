#
# Configuration file for forman. Simplifies development
# by starting all required processes at once.
#
# Node version:
#   > npm -g install foreman
#   > nf start
#

# we first have to make sure, that the backend server isn't running
pre: pm2 delete all

# start the backend server
api: cd rest && pm2 start processes.dev.json

# start the server
web: cd web && brunch watch -s
