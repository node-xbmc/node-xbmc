{defer} = require 'node-promise'

pubsub = require './PubSub'

class XbmcApi
  constructor: ->
    @queue = []
    @connection = null

    require('./Media').mixin         @
    require('./Notifications').mixin @
    require('./Handlers').mixin      @

    pubsub.on 'connection:open', =>      @message 'Attached to XBMC instance.'
    pubsub.on 'connection:notification', @notifications.delegate

  setConnection: (newConnection) =>
    @connection.close() if @connection
    @connection = newConnection
    @queue.forEach (item) -> @send item.method, item.params, item.dfd
    @queue = []
    setTimeout @initialize, 1000

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
    if data.thumbnail
      data.thumbnail = decodeURIComponent data.thumbnail.replace(/^image:\/\/|\/$/ig, '')
    return data

  message: (message = '', title = 'node-xbmc', displayTime = 6000) =>
    options =
      message:     message
      title:       title
      displayTime: displayTime
    @send 'GUI.ShowNotification', options

  connect: =>
    if @connection
      @connection.close() if @connection.isActive()
      @connection.create()

module.exports = XbmcApi
