pubsub = require './PubSub'

class Input
  @mixin: (api) =>
    @api = api
    api.input = {}
    api.input[name] = method for name, method of @
    delete api.input.mixin

  @SendText: (text, fn = null) =>
    dfd = @api.send 'Input.SendText',
      text: text
    dfd.then (data) ->
      pubsub.emit 'api:Input.SendText', data
      fn data if fn

  @ExecuteAction: (action, fn = null) =>
    if @inputActions.indexOf(action) is -1
      throw new Error "Input.Action #{action} does not exists"
    dfd = @api.send 'Input.ExecuteAction'
      action: action
    dfd.then (data) ->
      pubsub.emit 'api:Input.ExecuteAction', data
      fn data if fn

  @inputMethods: ['Up', 'Down', 'Left', 'Right', 'Select', 'ShowCodec', 'ShowOSD', 'Info', 'Home', 'Down', 'ContextMenu', "Back"]

  # TODO: ExecuteAction with http://wiki.xbmc.org/index.php?title=JSON-RPC_API/v6#Input.Action
  @inputActions: ["left", "right", "up", "down", "pageup", "pagedown", "select", "highlight", "parentdir", "parentfolder", "back", "previousmenu", "info", "pause", "stop", "skipnext", "skipprevious", "fullscreen", "aspectratio", "stepforward", "stepback", "bigstepforward", "bigstepback", "osd", "showsubtitles", "nextsubtitle", "codecinfo", "nextpicture", "previouspicture", "zoomout", "zoomin", "playlist", "queue", "zoomnormal", "zoomlevel1", "zoomlevel2", "zoomlevel3", "zoomlevel4", "zoomlevel5", "zoomlevel6", "zoomlevel7", "zoomlevel8", "zoomlevel9", "nextcalibration", "resetcalibration", "analogmove", "rotate", "rotateccw", "close", "subtitledelayminus", "subtitledelay", "subtitledelayplus", "audiodelayminus", "audiodelay", "audiodelayplus", "subtitleshiftup", "subtitleshiftdown", "subtitlealign", "audionextlanguage", "verticalshiftup", "verticalshiftdown", "nextresolution", "audiotoggledigital", "number0", "number1", "number2", "number3", "number4", "number5", "number6", "number7", "number8", "number9", "osdleft", "osdright", "osdup", "osddown", "osdselect", "osdvalueplus", "osdvalueminus", "smallstepback", "fastforward", "rewind", "play", "playpause", "delete", "copy", "move", "mplayerosd", "hidesubmenu", "screenshot", "rename", "togglewatched", "scanitem", "reloadkeymaps", "volumeup", "volumedown", "mute", "backspace", "scrollup", "scrolldown", "analogfastforward", "analogrewind", "moveitemup", "moveitemdown", "contextmenu", "shift", "symbols", "cursorleft", "cursorright", "showtime", "analogseekforward", "analogseekback", "showpreset", "presetlist", "nextpreset", "previouspreset", "lockpreset", "randompreset", "increasevisrating", "decreasevisrating", "showvideomenu", "enter", "increaserating", "decreaserating", "togglefullscreen", "nextscene", "previousscene", "nextletter", "prevletter", "jumpsms2", "jumpsms3", "jumpsms4", "jumpsms5", "jumpsms6", "jumpsms7", "jumpsms8", "jumpsms9", "filter", "filterclear", "filtersms2", "filtersms3", "filtersms4", "filtersms5", "filtersms6", "filtersms7", "filtersms8", "filtersms9", "firstpage", "lastpage", "guiprofile", "red", "green", "yellow", "blue", "increasepar", "decreasepar", "volampup", "volampdown", "channelup", "channeldown", "previouschannelgroup", "nextchannelgroup", "leftclick", "rightclick", "middleclick", "doubleclick", "wheelup", "wheeldown", "mousedrag", "mousemove", "noop"]

for _key in Input.inputMethods
  do ->
    key = _key
    Input[key] = (fn = null) ->
      dfd = @api.send "Input.#{key}"
      dfd.then (data) ->
        pubsub.emit "api:Input.#{key}", data
        fn data if fn

module.exports = Input
