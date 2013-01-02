class Handlers
  @mixin: (@api) ->
    @api.handlers = {}
    @api.handlers[name] = method for name, method of @
    delete @api.handlers.mixin

  @players: (data) =>
    playerId = (data.result?[0] || data.player || {}).playerid
    dfd = @api.send 'Player.GetItem', { playerid: playerId }
    dfd.then @playerItem

  @playerItem: (data) => do TODO

module.exports = Handlers
