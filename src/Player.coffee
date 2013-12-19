pubsub = require './PubSub'

class Player
  @mixin: (api) ->
    @api = api
    api.player = {}
    api.player[name] = method for name, method of @
    delete api.player.mixin

  @open: (item, options = {}, fn = null) =>
    dfd = @api.send 'Player.Open',
      item:    item
      options: options
    dfd.then (data) =>
      pubsub.emit 'player.open', data
      fn data if fn

  @getActivePlayers: (fn = null) =>
    dfd = @api.send 'Player.GetActivePlayers'
    dfd.then (data) =>
      pubsub.emit 'player.activePlayers', data
      fn data if fn

  @playPause: (fn = null) =>
    @getActivePlayers (data) ->
      playerId = data.result?.playerid || data.player?.playerid
      dfd = @api.send 'Player.PlayPause',
        playerid: playerId
      dfd.then (data) =>
        pubsub.emit 'player.playpause', data
        fn data if fn

  @stop: (fn = null) =>
    @getActivePlayers (data) ->
      playerId = data.result?.playerid || data.player?.playerid
      dfd = @api.send 'Player.Stop',
        playerid: playerId
      dfd.then (data) =>
        pubsub.emit 'player.stop', data
        fn data if fn

  @forward = (fn = null) =>
    @rewind true, fn

  @rewind = (forward = false, fn = null) =>
    speed = if forward then 'increment' else 'decrement'
    @getActivePlayers (data) ->
      playerId = data.result?.playerid || data.player?.playerid
      dfd = @api.send 'Player.SetSpeed',
        playerid: playerId
        speed:    speed
      dfd.then (data) =>
        pubsub.emit 'player.setspeed', data
        fn data if fn

  @openYoutube: (id, options = {}, fn = null) =>
    item = file: "plugin://plugin.video.youtube/?action=play_video&videoid=#{id}"
    @open item, options, fn

  @openFile: (file, options = {}, fn = null) =>
    item = file: file
    @open item, options, fn

module.exports = Player
