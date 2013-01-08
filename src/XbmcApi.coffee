{defer} = require 'node-promise'

pubsub = require './PubSub'

class XbmcApi
  constructor: (@options = {}) ->
    @queue = []
    @connection = null

    require('./Media').mixin         @
    require('./Notifications').mixin @
    require('./Handlers').mixin      @

    @pubsub = pubsub

    pubsub.on 'connection:open', =>
      unless @options.silent
        @message 'Attached to XBMC instance.'
    pubsub.on 'connection:notification', @notifications.delegate

    if @options.connection?
      @setConnection @options.connection

  on: (evt, callback) -> pubsub.on evt, callback
  emit: (evt, data) -> pubsub.emit evt, data

  setConnection: (newConnection) =>
    @connection.close() if @connection
    @connection = newConnection
    @queue.forEach (item) -> @send item.method, item.params, item.dfd
    @queue = []
    do @initialize

  initialize: =>
    obj = @send 'Player.GetActivePlayers'
    obj.then @handlers.players

  send: (method, params = {}, dfd = null) =>
    data =
      method: method
      params: params
    unless @connection
      data.dfd = defer()
      @queue.push data
      return data.dfd.promise
    connDfd = @connection.send data
    connDfd.pipe dfd.resolve if dfd
    return connDfd

  scrub: (data) ->
    data.thumbnail = decodeURIComponent data.thumbnail.replace(/^image:\/\/|\/$/ig, '') if data.thumbnail
    return data

  message: (message = '', title = 'node-xbmc', displayTime = 6000) =>
    options =
      message:     message
      title:       title
      displaytime: displayTime
    @send 'GUI.ShowNotification', options

  connect: =>
    if @connection
      @connection.close() if @connection.isActive()
      @connection.create()

module.exports = XbmcApi
