# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

TCPConnection = require '../src/TCPConnection'
XbmcApi =       require '../src/XbmcApi'

connection = new TCPConnection
  host:    '127.0.0.1'
  port:    9090
  verbose: true
xbmcApi = new XbmcApi

xbmcApi.setConnection connection

console.log 'done'
