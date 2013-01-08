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

id = process.argv[2] || 'QH2-TGUlwu4' # nyan cat
xbmcApi.player.openYoutube id
