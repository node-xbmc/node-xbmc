XBMC node controler
===================

This module uses [XBMC JSON-RPC Api V6](http://wiki.xbmc.org/index.php?title=JSON-RPC_API/v6) to provice a rich and simple API to communicate with XMBC instances.

Documentation
=============

The `xbmc` module contains the following classes:

* `XbmcApi` : API wrapper of available actions, notifications and media handling
* `TCPConnection` : TCP Client to communicate with XBMC

Basics
------

All classes are created asynchronously.

All classes share a PubSub instance.
`XbmcApi.on` and `XbmcApi.emit` are wrappers to the shared PubSub. For instance:

```coffee
connection = new TCPConnection
  host:    '127.0.0.1'
  port:    9090
  verbose: true
xbmc = new xbmcApi
xbmc.setConnection connection

xbmc.on 'connection:open',                        -> console.log 'Connection is open'
xbmc.on 'connection:data', (data)                 -> console.log 'Received data:',         data
xbmc.on 'connection:notification', (notification) -> console.log 'Received notification:', notification
```

TCPConnection uses a deferred (promise) mechanism.
Following two examples are both working:

```coffee
connection = new TCPConnection
  host:    '127.0.0.1'
  port:    9090
  verbose: true

xbmc = new xbmcApi
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
