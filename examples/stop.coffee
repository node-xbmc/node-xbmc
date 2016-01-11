#!/usr/bin/env coffee

# clear terminal
#process.stdout.write '\u001B[2J\u001B[0;0f'

{TCPConnection, XbmcApi} = require '..'
config =                   require './config'

connection = new TCPConnection
  host:       config.connection.host
  port:       config.connection.port
  verbose:    false
xbmcApi = new XbmcApi
  silent:     false
  connection: connection

xbmcApi.player.stop ->
  console.log 'done'
