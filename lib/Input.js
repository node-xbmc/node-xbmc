// Generated by CoffeeScript 1.10.0
(function() {
  var Input, _key, debug, fn1, i, len, pubsub, ref;

  pubsub = require('./PubSub');

  debug = require('debug')('xbmc:Input');

  Input = (function() {
    function Input() {}

    Input.mixin = function(api) {
      var method, name;
      debug('mixin');
      Input.api = api;
      api.input = {};
      for (name in Input) {
        method = Input[name];
        api.input[name] = method;
      }
      return delete api.input.mixin;
    };

    Input.SendText = function(text, fn) {
      var dfd;
      if (fn == null) {
        fn = null;
      }
      debug('SendText', text);
      dfd = Input.api.send('Input.SendText', {
        text: text
      });
      return dfd.then(function(data) {
        pubsub.emit('api:Input.SendText', data);
        if (fn) {
          return fn(data);
        }
      });
    };

    Input.ExecuteAction = function(action, fn) {
      var dfd;
      if (fn == null) {
        fn = null;
      }
      debug('ExecuteAction', action);
      if (Input.inputActions.indexOf(action) === -1) {
        throw new Error("Input.Action " + action + " does not exists");
      }
      dfd = Input.api.send('Input.ExecuteAction', {
        action: action
      });
      return dfd.then(function(data) {
        pubsub.emit('api:Input.ExecuteAction', data);
        if (fn) {
          return fn(data);
        }
      });
    };

    Input.inputMethods = ['Up', 'Down', 'Left', 'Right', 'Select', 'ShowCodec', 'ShowOSD', 'Info', 'Home', 'Down', 'ContextMenu', "Back"];

    Input.inputActions = ["left", "right", "up", "down", "pageup", "pagedown", "select", "highlight", "parentdir", "parentfolder", "back", "previousmenu", "info", "pause", "stop", "skipnext", "skipprevious", "fullscreen", "aspectratio", "stepforward", "stepback", "bigstepforward", "bigstepback", "osd", "showsubtitles", "nextsubtitle", "codecinfo", "nextpicture", "previouspicture", "zoomout", "zoomin", "playlist", "queue", "zoomnormal", "zoomlevel1", "zoomlevel2", "zoomlevel3", "zoomlevel4", "zoomlevel5", "zoomlevel6", "zoomlevel7", "zoomlevel8", "zoomlevel9", "nextcalibration", "resetcalibration", "analogmove", "rotate", "rotateccw", "close", "subtitledelayminus", "subtitledelay", "subtitledelayplus", "audiodelayminus", "audiodelay", "audiodelayplus", "subtitleshiftup", "subtitleshiftdown", "subtitlealign", "audionextlanguage", "verticalshiftup", "verticalshiftdown", "nextresolution", "audiotoggledigital", "number0", "number1", "number2", "number3", "number4", "number5", "number6", "number7", "number8", "number9", "osdleft", "osdright", "osdup", "osddown", "osdselect", "osdvalueplus", "osdvalueminus", "smallstepback", "fastforward", "rewind", "play", "playpause", "delete", "copy", "move", "mplayerosd", "hidesubmenu", "screenshot", "rename", "togglewatched", "scanitem", "reloadkeymaps", "volumeup", "volumedown", "mute", "backspace", "scrollup", "scrolldown", "analogfastforward", "analogrewind", "moveitemup", "moveitemdown", "contextmenu", "shift", "symbols", "cursorleft", "cursorright", "showtime", "analogseekforward", "analogseekback", "showpreset", "presetlist", "nextpreset", "previouspreset", "lockpreset", "randompreset", "increasevisrating", "decreasevisrating", "showvideomenu", "enter", "increaserating", "decreaserating", "togglefullscreen", "nextscene", "previousscene", "nextletter", "prevletter", "jumpsms2", "jumpsms3", "jumpsms4", "jumpsms5", "jumpsms6", "jumpsms7", "jumpsms8", "jumpsms9", "filter", "filterclear", "filtersms2", "filtersms3", "filtersms4", "filtersms5", "filtersms6", "filtersms7", "filtersms8", "filtersms9", "firstpage", "lastpage", "guiprofile", "red", "green", "yellow", "blue", "increasepar", "decreasepar", "volampup", "volampdown", "channelup", "channeldown", "previouschannelgroup", "nextchannelgroup", "leftclick", "rightclick", "middleclick", "doubleclick", "wheelup", "wheeldown", "mousedrag", "mousemove", "noop"];

    return Input;

  })();

  ref = Input.inputMethods;
  fn1 = function() {
    var key;
    key = _key;
    return Input[key] = function(fn) {
      var dfd;
      if (fn == null) {
        fn = null;
      }
      debug('Input', key);
      dfd = this.api.send("Input." + key);
      return dfd.then(function(data) {
        pubsub.emit("api:Input." + key, data);
        if (fn) {
          return fn(data);
        }
      });
    };
  };
  for (i = 0, len = ref.length; i < len; i++) {
    _key = ref[i];
    fn1();
  }

  module.exports = Input;

}).call(this);
