#
# Configuration file for forman. Simplifies development
# by starting all required processes at once.
#
# Node version:
#   > npm -g install foreman
#   > nf start
#

# start the server
web: cd web && forever -m 5 --minUptime 1000 --spinSleepTime 5000 -c coffee server.coffee
