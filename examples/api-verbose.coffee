#!/usr/bin/env coffee

# clear terminal
#process.stdout.write '\u001B[2J\u001B[0;0f'

TCPConnection = require '../lib/TCPConnection'
XbmcApi =       require '../lib/XbmcApi'
config =        require './config'

connection = new TCPConnection
  host:    config.connection.host
  port:    config.connection.port
  verbose: true
xbmcApi = new XbmcApi

xbmcApi.setConnection connection

console.log 'done'
