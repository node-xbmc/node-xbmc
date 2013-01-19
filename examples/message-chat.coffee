#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

TCPConnection = require '../lib/TCPConnection'
XbmcApi =       require '../lib/XbmcApi'
config =        require './config'

connection = new TCPConnection
  host:       config.connection.host
  port:       config.connection.port
  verbose:    false
xbmcApi = new XbmcApi
  silent:     true
  connection: connection

readline = require 'readline'
rl = readline.createInterface
  input:  process.stdin
  output: process.stdout

prompt = ->
  rl.question 'xbmc-chat> ', (name) ->
    xbmcApi.message name
    do prompt

xbmcApi.on 'connection:open', prompt
