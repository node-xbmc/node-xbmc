pubsub = require './PubSub'

class Input
  @mixin: (api) =>
    @api = api
    api.input = {}
    api.input[name] = method for name, method of @
    delete api.input.mixin

for _key in ['Up', 'Down', 'Left', 'Right', 'Select', 'SendText', 'ShowCodec', 'ShowOSD', 'Info', 'Home', 'Down', 'ContextMenu', "Back"]
  do ->
    key = _key
    key_lower = do key.toLowerCase
    Input[key_lower] = (fn = null) ->
      dfd = @api.send "Input.#{key}"
      dfd.then (data) ->
        pubsub.emit "input.#{key_lower}", data
        fn data if fn

# TODO: ExecuteAction with http://wiki.xbmc.org/index.php?title=JSON-RPC_API/v6#Input.Action

module.exports = Input
