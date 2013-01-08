#!/usr/bin/env coffee

# clear terminal
#process.stdout.write '\u001B[2J\u001B[0;0f'

{TCPConnection, XbmcApi} = require '..'

connection = new TCPConnection
  host:       '127.0.0.1'
  port:       9090
  verbose:    false
xbmcApi = new XbmcApi
  silent:     true
  connection: connection

file = process.argv[2] || '/media/movies/movie1.avi'
xbmcApi.player.openFile file
