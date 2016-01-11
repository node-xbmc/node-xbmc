pubsub = require './PubSub'
debug = require('debug') 'xbmc:Player'

class Player
  @mixin: (api) ->
    debug 'mixin'
    @api = api
    api.player = {}
    api.player[name] = method for name, method of @
    delete api.player.mixin

  @open: (item, options = {}, fn = null) =>
    debug 'open', item, options
    dfd = @api.send 'Player.Open',
      item:    item
      options: options
    dfd.then (data) =>
      pubsub.emit 'player.open', data
      fn data if fn

  @getActivePlayers: (fn = null) =>
    debug 'getActivePlayers'
    dfd = @api.send 'Player.GetActivePlayers'
    dfd.then (data) =>
      pubsub.emit 'player.activePlayers', data
      fn data if fn

  @playPause: (fn = null) =>
    debug 'playPause'
    @getActivePlayers (data) =>
      playerId = data.result?[0]?.playerid || data.player?.playerid
      unless playerId
        debug 'no playerId, is there a media playing right now ?'
        return

      dfd = @api.send 'Player.PlayPause',
        playerid: playerId
      dfd.then (data) =>
        pubsub.emit 'player.playpause', data
        fn data if fn

  @stop: (fn = null) =>
    debug 'stop'
    @getActivePlayers (data) =>
      playerId = data.result?[0]?.playerid || data.player?.playerid
      unless playerId
        debug 'no playerId, is there a media playing right now ?'
        return
      dfd = @api.send 'Player.Stop', playerid: playerId
      dfd.then (data) =>
        pubsub.emit 'player.stop', data
        fn data if fn

  @forward = (fn = null) =>
    debug 'forward'
    @rewind true, fn

  @rewind = (forward = false, fn = null) =>
    speed = if forward then 'increment' else 'decrement'
    debug 'rewind', speed
    @getActivePlayers (data) =>
      playerId = data.result?[0]?.playerid || data.player?.playerid
      unless playerId
        debug 'no playerId, is there a media playing right now ?'
        return

      dfd = @api.send 'Player.SetSpeed',
        playerid: playerId
        speed:    speed
      dfd.then (data) =>
        pubsub.emit 'player.setspeed', data
        fn data if fn

  @openYoutube: (id, options = {}, fn = null) =>
    debug 'openYoutube', id, options
    item = file: "plugin://plugin.video.youtube/?action=play_video&videoid=#{id}"
    @open item, options, fn

  @openFile: (file, options = {}, fn = null) =>
    debug 'openFile', file, options
    item = file: file
    @open item, options, fn

module.exports = Player
