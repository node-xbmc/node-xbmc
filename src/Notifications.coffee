pubsub = require './PubSub'
debug = require('debug') 'xbmc:Notifications'

class Notifications
  @mixin: (api) ->
    debug 'mixin'
    @api = api
    api.notifications = {}
    api.notifications[name] = method for name, method of @
    delete api.notifications.mixin

  @delegate: (data) =>
    debug 'delegate', data
    type = data.method.split('.On')[1].toLowerCase()
    pubsub.emit "notification:#{type}", data
    if @[type]?
      @[type] data.params.data
    else
      console.log "Unhandled notification type: #{type}"

  @play: (data) =>
    debug 'play', data
    @api.handlers.players data

  @stop: (data = null) =>
    debug 'stop', data
    pubsub.emit 'api:playerStopped', data

  @add: => debug 'add'

  @update: => debug 'update'

  @clear: => debug 'clear'

  @scanstarted: => debug 'scanstarted'

  @scanfinished: => debug 'scandfinished'

  @pause: => debug 'pause'

  @screensaveractivated: => debug 'screensaveractivated'

  @screensaverdeactivated: => debug 'screensaverdeactivated'

  @seek: => debug 'seek'

  @volumechanged: => debug 'volumechanged'

  @inputrequested: =>
    debug 'inputrequested'
    pubsub.emit 'api:Input.OnInputRequested'

  @inputfinished: =>
    debug 'inputfinished'
    pubsub.emit 'api:Input.OnInputFinished'

  @wake: => debug 'wake'

  @sleep: => debug 'sleep'

  @remove: => debug 'remove'

module.exports = Notifications
