module.exports = {}

for mod in ['XbmcApi', 'TCPConnection', 'Player', 'Input', 'Handlers', 'Media', 'Notifications']
  module.exports[mod] = require("./#{mod}")

module.exports.pubsub = require './PubSub'
