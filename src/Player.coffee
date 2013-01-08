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

  @openYoutube: (id, options = {}, fn = null) =>
    item = file: "plugin://plugin.video.youtube/?action=play_video&videoid=#{id}"
    @open item, options, fn

  @openFile: (file, options = {}, fn = null) =>
    item = file: file
    @open item, options, fn

module.exports = Player
