#{EventEmitter} = require 'events'

pubsub = require './PubSub'

{defer} = require 'node-promise'
net =     require 'net'

class Connection
  constructor: (@options = {}) ->
    @options.port       ?= 9090
    @options.host       ?= '127.0.0.1'
    @options.user       ?= 'xbmc'
    @options.password   ?= false
    @options.verbose    ?= false
    @options.connectNow ?= true

    @readRaw = ''
    @sendQueue = []
    @deferreds = {}
    if @options.connectNow
      do @create

  create: =>
    @socket = net.connect
      host: @options.host
      port: @options.port
    @socket.on 'connect',    @onOpen
    @socket.on 'data',       @onMessage
    @socket.on 'error',      @onError
    @socket.on 'disconnect', @onClose
    @socket.on 'close',      @onClose

  @_id: 0
  @generateId: -> "__id#{++Connection._id}"

  isActive: =>
    return @socket?._connecting is false

  send: (data = null) =>
    throw new Error 'Connection: Unknown arguments' if not data
    data.id ?= do Connection.generateId
    dfd = @deferreds[data.id] ?= defer()
    unless @isActive()
      @sendQueue.push data
    else
      data.jsonrpc = '2.0'
      data = JSON.stringify data
      @publish 'send', data
      @socket.write data
    return dfd.promise

  close: (fn = null) =>
    try
      do @socket.end
      do @socket.destroy
      do fn if fn
    catch err
      @publish 'error', err
      fn err if fn

  publish: (topic, data = {}) =>
    #data.connection = @
    if @options.verbose
      dataVerbose = if typeof(data) is 'object' then JSON.stringify data else data
      console.log "[connection:#{topic}]", dataVerbose if @options.verbose
    pubsub.emit "connection:#{topic}", data

  onOpen: =>
    @publish 'open'
    setTimeout (=>
      for item in @sendQueue
        @send item
      @sendQueue = []
    ), 500

  onError: (evt) =>
    @publish 'error', evt

  onClose: (evt) =>
    @publish 'close', evt

  parseBuffer: (buffer) =>
    @readRaw += buffer.toString()
    lines = []
    try
      line = JSON.parse @readRaw
      lines.push line
      @readRaw = ''
    catch err
      # Hack: sometimes json are concat
      splitStr = '{"jsonrpc":"2.0"'
      rawlines = @readRaw.split splitStr
      lines = []
      for rawline in rawlines
        continue unless rawline.length
        str = splitStr + rawline
        try
          line = JSON.parse str
          lines.push line
          @readRaw = ''
    return lines

  onMessage: (buffer) =>
    lines = @parseBuffer buffer
    for line in lines
      evt = {}
      evt.data = line
      id = evt.data?.id
      dfd = @deferreds[id]
      delete @deferreds[id]
      if evt.data.error
        @onError evt
        dfd.reject evt.data if dfd
        continue
      @publish 'data', evt.data
      if evt.data.method?.indexOf '.On' > 1
        @publish 'notification', evt.data
      dfd.resolve evt.data if dfd

module.exports = Connection
