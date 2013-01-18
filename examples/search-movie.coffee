#!/usr/bin/env coffee

# clear terminal
#process.stdout.write '\u001B[2J\u001B[0;0f'

Table =                    require 'cli-table'
{TCPConnection, XbmcApi} = require '..'
config =                   require './config'

connection = new TCPConnection
  host:    config.connection.host
  port:    config.connection.port
  verbose: false
xbmcApi = new XbmcApi
  silent:  true
  connection: connection

xbmcApi.media.movies
  properties: ['file']

query = process.argv[2]
re = new RegExp query, "i"

table = new Table
  head:      ['#', 'Label']
table.options.style.compact = true

xbmcApi.on 'api:movies', (movies) ->
  for movie in movies
    table.push [movie.movieid, movie.label, movie.file] if movie.label.match re
  console.log "#{table.length} Movies"
  console.log table.toString()
  do xbmcApi.disconnect -> process.exit 0
