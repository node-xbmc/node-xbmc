// Generated by CoffeeScript 1.4.0
(function() {
  var TCPConnection, XbmcApi, connection, xbmcApi;

  TCPConnection = require('../lib/TCPConnection');

  XbmcApi = require('../lib/XbmcApi');

  connection = new TCPConnection({
    host: '127.0.0.1',
    port: 9090,
    verbose: true
  });

  xbmcApi = new XbmcApi;

  xbmcApi.setConnection(connection);

  console.log('done');

}).call(this);