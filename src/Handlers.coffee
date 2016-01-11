pubsub = require './PubSub'
debug = require('debug') 'xbmc:Handlers'

class Handlers
  @mixin: (@api) ->
    debug 'mixin'
    @api.handlers = {}
    @api.handlers[name] = method for name, method of @
    delete @api.handlers.mixin

  @players: (data) =>
    debug 'players', data
    playerId = data.result?[0]?.playerid || data.player?.playerid

    if playerId
      dfd = @api.send 'Player.GetItem', { playerid: playerId }
      dfd.then @playerItem

  @playerItem: (data) =>
    debug 'playerItem', data
    unless data.result.item.id
      pubsub.emit 'api:video', data.result.item
    else
      data = data.result.item
      fn = @api.media[data.type]
      if fn
        fn data.id
      else
        console.log 'Unhandled played item:', data

module.exports = Handlers
