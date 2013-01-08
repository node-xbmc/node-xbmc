#!/usr/bin/env coffee

# clear terminal
#process.stdout.write '\u001B[2J\u001B[0;0f'

Table = require 'cli-table'
{TCPConnection, XbmcApi} = require '..'

connection = new TCPConnection
  host:    '127.0.0.1'
  port:    9090
  verbose: false
xbmcApi = new XbmcApi
  silent:  true
  connection: connection

xbmcApi.media.movies
  properties: ['genre', 'year']

query = process.argv[2]
re = new RegExp query, "i"

table = new Table
  head:      ['#', 'Label', 'Genre', 'Year']
table.options.style.compact = true

xbmcApi.on 'api:movies', (movies) ->
  for movie in movies
    table.push [movie.movieid, movie.label, movie.genre.join(', '), movie.year] if movie.label.match re
  console.log "#{table.length} Movies"
  console.log table.toString()
