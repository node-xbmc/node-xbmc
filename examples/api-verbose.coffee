#!/usr/bin/env coffee

# clear terminal
#process.stdout.write '\u001B[2J\u001B[0;0f'

TCPConnection = require '../lib/TCPConnection'
XbmcApi =       require '../lib/XbmcApi'

connection = new TCPConnection
  host:    '127.0.0.1'
  port:    9090
  verbose: true
xbmcApi = new XbmcApi

xbmcApi.setConnection connection

console.log 'done'
