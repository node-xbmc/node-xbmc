#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

TCPConnection = require '../lib/TCPConnection'
XbmcApi =       require '../lib/XbmcApi'

connection = new TCPConnection
  host:       '127.0.0.1'
  port:       9090
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
