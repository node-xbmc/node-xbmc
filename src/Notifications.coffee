pubsub = require './PubSub'

class Notifications
  @mixin: (api) ->
    @api = api
    api.notifications = {}
    api.notifications[name] = method for name, method of @
    delete api.notifications.mixin

  @delegate: (data) =>
    type = data.method.split('.On')[1].toLowerCase()
    fn = @[type]
    pubsub.emit "notification:#{type}", data
    if fn
      fn data.params.data
    else
      console.log "Unhandled notification type: #{type}"

  @play: (data) => @api.handlers.players data

  @stop: => pubsub.emit 'api:playerStopped'

  @add: =>

  @update: =>

  @clear: =>

  @scanstarted: =>

  @scanfinished: =>

  @pause: =>

  @screensaveractivated: =>

  @screensaverdeactivated: =>

module.exports = Notifications
