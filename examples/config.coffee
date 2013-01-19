module.exports =
  connection:
    host: '127.0.0.1'
    port: 9090

try
  module.exports = require './config.local'
catch e


