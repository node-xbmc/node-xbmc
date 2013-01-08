#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

TCPConnection = require '../lib/TCPConnection'
XbmcApi =       require '../lib/XbmcApi'

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

  Table = require 'cli-table'
  table = new Table
    head:      ['#', 'Label', 'Genre', 'Year']
    #colWidths: [Number(movies).toString().length + 3, 60, 60, 4 + 3]
  table.push [movie.movieid, movie.label, movie.genre.join(', '), movie.year] for movie in movies
  console.log table.toString()
