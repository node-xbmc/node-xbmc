#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

TCPConnection = require '../lib/TCPConnection'
XbmcApi =       require '../lib/XbmcApi'
config =        require './config'

connection = new TCPConnection
  host:       config.connection.host
  port:       config.connection.port
  verbose:    true
xbmcApi = new XbmcApi
  silent:     true
  connection: connection

xbmcApi.on 'connection:open', ->
  setTimeout  (-> xbmcApi.message '2s: Hello World'), 2000
  setTimeout  (-> xbmcApi.message '5s: Lorem Ipsum'), 5000
  setTimeout  (-> xbmcApi.message '9s: Batman !!!'),  9000
  setInterval (-> xbmcApi.message '10s: Interval'),  10000
