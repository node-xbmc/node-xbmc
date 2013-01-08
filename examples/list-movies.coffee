#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

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
  #limits: start: 0, end: 10
  properties: ['genre', 'year']

xbmcApi.on 'api:movies', (movies) ->
  console.log "#{movies.length} Movies"

  table = new Table
    head:      ['#', 'Label', 'Genre', 'Year']
  table.options.style.compact = true
  table.push [movie.movieid, movie.label, movie.genre.join(', '), movie.year] for movie in movies
  console.log table.toString()
