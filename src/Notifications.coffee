pubsub = require './PubSub'

class Notifications
  @mixin: (api) ->
    @api = api
    api.notifications = {}
    api.notifications[name] = method for name, method of @
    delete api.notifications.mixin

  @delegate: (data) =>
    type = data.method.split('.On')[1].toLowerCase()
    pubsub.emit "notification:#{type}", data
    if @[type]?
      @[type] data.params.data
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

  @seek: =>

  @volumechanged: =>

  @inputrequested: => pubsub.emit 'api:Input.OnInputRequested'

  @inputfinished: =>  pubsub.emit 'api:Input.OnInputFinished'

  @wake: =>

  @sleep: =>

  @remove: =>

module.exports = Notifications
