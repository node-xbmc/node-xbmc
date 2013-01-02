pubsub = require './PubSub'

class Handlers
  @mixin: (@api) ->
    @api.handlers = {}
    @api.handlers[name] = method for name, method of @
    delete @api.handlers.mixin

  @players: (data) =>
    playerId = (data.result?[0] || data.player || {}).playerid
    if playerId
      dfd = @api.send 'Player.GetItem', { playerid: playerId }
      dfd.then @playerItem

  @playerItem: (data) =>
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
