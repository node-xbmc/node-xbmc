debug = require('debug') 'xbmc:TCPConnection'
pubsub = require './PubSub'

{defer} = require 'node-promise'
clarinet = require 'clarinet'
net =     require 'net'

class Connection
  constructor: (@options = {}) ->
    debug 'constructor', @options
    @options.port       ?= 9090
    @options.host       ?= '127.0.0.1'
    @options.user       ?= 'xbmc'
    @options.password   ?= false
    @options.verbose    ?= false
    @options.connectNow ?= true

    do @_createParser

    @sendQueue = []
    @deferreds = {}
    if @options.connectNow
      do @create

  create: =>
    debug 'create'
    @socket = net.connect
      host: @options.host
      port: @options.port
    @socket.on 'connect',    @onOpen
    @socket.on 'data',       @onData
    @socket.on 'error',      @onError
    @socket.on 'disconnect', @onClose
    @socket.on 'close',      @onClose

  @_id: 0
  @generateId: -> "__id#{++Connection._id}"

  isActive: =>
    debug 'isActive'
    return @socket?._connecting is false

  send: (data = null) =>
    debug 'send', JSON.stringify data
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
    debug 'close'
    try
      do @socket.end
      do @socket.destroy
      do fn if fn
    catch err
      @publish 'error', err
      fn err if fn

  publish: (topic, data = {}) =>
    #data.connection = @
    dataVerbose = if typeof(data) is 'object' then JSON.stringify data else data
    debug 'publish', topic, dataVerbose
    pubsub.emit "connection:#{topic}", data

  onOpen: =>
    debug 'onOpen'
    @publish 'open'
    setTimeout (=>
      for item in @sendQueue
        @send item
      @sendQueue = []
    ), 500

  onError: (evt) =>
    debug 'onError', JSON.stringify evt
    @publish 'error', evt

  onClose: (evt) =>
    debug 'onClose', evt
    @publish 'close', evt
    @parser.close()

  onData: (buffer) =>
    debug 'onData'
    @parser.write buffer.toString()

  _createParser: =>
    @parser = clarinet.parser()
    stack = []
    currentKey = null
    addValue = (val) =>
      if Array.isArray stack[0]
        stack[0].push val
      else
        stack[0][currentKey] = val
    @parser.onerror = (ex) =>
      #debug 'parser.onerror', ex, stack.length
      throw new Error "JSON parse error: #{ex}"
    @parser.onvalue = (val) =>
      #debug 'parser.onvalue', val, stack.length
      addValue(val)
    @parser.onopenobject = (key) =>
      #debug 'parser.onopenobject', key, stack.length
      obj = {}
      addValue obj if stack.length
      stack.unshift obj
      currentKey = key
    @parser.onkey = (key) =>
      #debug 'parser.onkey', key, stack.length
      currentKey = key
    @parser.oncloseobject = () =>
      #debug 'parser.oncloseobject', stack.length
      obj = stack.shift()
      if stack.length == 0
        @_receive obj
    @parser.onopenarray = () =>
      #debug 'parser.onopenarray', stack.length
      arr = []
      addValue arr if stack.length
      stack.unshift arr
    @parser.onclosearray = () =>
      #debug 'parser.onclosearray', stack.length
      stack.shift()
    @parser.onend = () =>
      #debug 'parser.onend'

  _receive: (data) =>
    evt =
      data: data
    id = evt.data?.id
    dfd = @deferreds[id]
    delete @deferreds[id]
    if evt.data.error
      @onError evt
      dfd.reject evt.data if dfd
    else
      @publish 'data', evt.data
      if evt.data.method?.indexOf '.On' > 1
        @publish 'notification', evt.data
      dfd.resolve evt.data if dfd

module.exports = Connection
