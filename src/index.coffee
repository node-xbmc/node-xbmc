module.exports = {}

for mod in ['XbmcApi', 'TCPConnection', 'Player', 'Input', 'Handler', 'Media', 'Notifications']
  module.exports[mod] = require("./#{mod}")[mod]

module.exports.pubsub = require' ./pubsub'
