{EventEmitter} = require 'events'

class PubSub extends EventEmitter
  constructor: -> super

pubsub = new PubSub()

module.exports = pubsub
