{EventEmitter} = require 'events'
debug = require('debug') 'xbmc:PubSub'

class PubSub extends EventEmitter
  constructor: ->
    debug 'constructor'
    super

pubsub = new PubSub()

module.exports = pubsub
