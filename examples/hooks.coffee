#!/usr/bin/env coffee

# clear terminal
#process.stdout.write '\u001B[2J\u001B[0;0f'

TCPConnection = require '../lib/TCPConnection'
XbmcApi =       require '../lib/XbmcApi'
config =        require './config'

connection = new TCPConnection
  host:    config.connection.host
  port:    config.connection.port
  verbose: false
xbmcApi = new XbmcApi

xbmcApi.setConnection connection

xbmcApi.on 'connection:data',                     -> console.log 'onData'
xbmcApi.on 'connection:open',                     -> console.log 'onOpen'
xbmcApi.on 'connection:close',                    -> console.log 'onClose'
xbmcApi.on 'connection:error',                    -> console.log 'onError'
xbmcApi.on 'api:movie',                           (details) -> console.log 'onMovie', details
xbmcApi.on 'api:episode',                         (details) -> console.log 'onEpisode', details
xbmcApi.on 'api:playerStopped',                   -> console.log 'onPlayerStopped'
xbmcApi.on 'api:video',                           -> console.log 'onVideo'
xbmcApi.on 'notification:play',                   -> console.log 'onPlay'
xbmcApi.on 'notification:pause',                  -> console.log 'onPause'
xbmcApi.on 'notification:add',                    -> console.log 'onPause'
xbmcApi.on 'notification:update',                 -> console.log 'onPause'
xbmcApi.on 'notification:clear',                  -> console.log 'onPause'
xbmcApi.on 'notification:scanstarted',            -> console.log 'onPause'
xbmcApi.on 'notification:scanfinished',           -> console.log 'onPause'
xbmcApi.on 'notification:screensaveractivated',   -> console.log 'onPause'
xbmcApi.on 'notification:screensaverdeactivated', -> console.log 'onPause'

console.log 'done'
