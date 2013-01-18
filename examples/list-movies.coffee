#!/usr/bin/env coffee

# clear terminal
#process.stdout.write '\u001B[2J\u001B[0;0f'

Table =                    require 'cli-table'
{TCPConnection, XbmcApi} = require '..'
config =                   require './config'

connection = new TCPConnection
  host:    config.connection.host
  port:    config.connection.port
  verbose: true
xbmcApi = new XbmcApi
  silent:  true
  connection: connection

xbmcApi.media.movies
  #limits: start: 0, end: 10
  properties: ['genre', 'year']

table = new Table
  head:      ['#', 'Label', 'Genre', 'Year']
table.options.style.compact = true

xbmcApi.on 'api:movies', (movies) ->
  console.log "#{movies.length} Movies"
  table.push [movie.movieid, movie.label, movie.genre.join(', '), movie.year] for movie in movies
  console.log table.toString()
