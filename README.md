XBMC node controller
====================

[![Build Status](https://travis-ci.org/moul/node-xbmc.png?branch=master)](https://travis-ci.org/moul/node-xbmc)
[![Dependency Status](https://david-dm.org/moul/node-xbmc.png?theme=shields.io)](https://david-dm.org/moul/node-xbmc)
[![authors](https://sourcegraph.com/api/repos/github.com/moul/node-xbmc/badges/authors.png)](https://sourcegraph.com/github.com/moul/node-xbmc)
[![library users](https://sourcegraph.com/api/repos/github.com/moul/node-xbmc/badges/library-users.png)](https://sourcegraph.com/github.com/moul/node-xbmc)
[![Total views](https://sourcegraph.com/api/repos/github.com/moul/node-xbmc/counters/views.png)](https://sourcegraph.com/github.com/moul/node-xbmc)
[![Views in the last 24 hours](https://sourcegraph.com/api/repos/github.com/moul/node-xbmc/counters/views-24h.png)](https://sourcegraph.com/github.com/moul/node-xbmc)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/moul/node-xbmc/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

![NPM Badge](https://nodei.co/npm/xbmc.png?downloads=true&stars=true "NPM Badge")

This module uses [XBMC JSON-RPC Api V6](http://wiki.xbmc.org/index.php?title=JSON-RPC_API/v6) to provice a rich and simple API to communicate with XMBC instances.

[![Gitter chat](https://badges.gitter.im/moul/node-xbmc.png)](https://gitter.im/moul/node-xbmc)

Documentation
=============

The `xbmc` module contains the following classes:

* `XbmcApi` : API wrapper of available actions, notifications and media handling
* `TCPConnection` : TCP Client to communicate with XBMC

Basics
------

All classes are created asynchronously.

All classes are sharing an `EventEmitter` instance.
`XbmcApi.on` and `XbmcApi.emit` are wrappers to the shared PubSub. For instance:

In CoffeeScript :

```coffee
{TCPConnection, XbmcApi} = require 'xbmc'

connection = new TCPConnection
  host:    '127.0.0.1'
  port:    9090
  verbose: true
xbmc = new XbmcApi
xbmc.setConnection connection

xbmc.on 'connection:open',                        -> console.log 'Connection is open'
xbmc.on 'connection:data', (data)                 -> console.log 'Received data:',         data
xbmc.on 'connection:notification', (notification) -> console.log 'Received notification:', notification
```

In JavaScript :

```javascript
  var Xbmc = require('xbmc');

  var connection = new Xbmc.TCPConnection({
    host: '127.0.0.1',
    port: 9000,
    verbose: false
  });
  var xbmcApi = new Xbmc.XbmcApi;

  xbmcApi.setConnection(connection);

  xbmcApi.on('connection:data', function()  { console.log('onData');  });
  xbmcApi.on('connection:open', function()  { console.log('onOpen');  });
  xbmcApi.on('connection:close', function() { console.log('onClose'); });
```

TCPConnection uses a deferred (promise) mechanism.
Following two examples are both working:

```coffee
{TCPConnection, XbmcApi} = require 'xbmc'

connection = new TCPConnection
  host:    '127.0.0.1'
  port:    9090
  verbose: true

xbmc = new XbmcApi
xbmc.setConnection connection

# run actions after received a 'connection:open' event
xbmc.on 'connection:open', ->
  xbmc.message 'Hello World'
```

```coffee
connection = new TCPConnection
  host:    '127.0.0.1'
  port:    9090
  verbose: true

xbmc = new xbmcApi
xbmc.setConnection connection

# enqueu actions so they are called a soon as connection is opened
xbmc.message 'Hello World'
```

SEE ALSO
========

* [Examples](https://github.com/moul/node-xbmc/tree/master/examples)

TODO
====

More actions, new helpers, tests, ...
