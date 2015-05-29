#!/usr/bin/env node
db.hosts.drop()
db.hosts.insert({host: "Dummy Backend Server", url: "http://localhost:8081"})
