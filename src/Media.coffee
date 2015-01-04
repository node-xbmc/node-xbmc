pubsub = require './PubSub'
debug = require('debug') 'xbmc:Media'

class Media
  @mixin: (api) ->
    debug 'mixin'
    @api = api
    api.media = {}
    api.media[name] = method for name, method of @
    delete api.media.mixin

  @_result: (data, field, evt, fn) =>
    d = @api.scrub data.result[field]
    pubsub.emit 'api:' + evt, d
    fn d if fn
    d

  @tvshows: (options = {}, fn = null) =>
    debug 'tvshows', options
    args =
      properties: options.properties || []
      sort:       options.sort       || {}
      limits:     options.limits     || {}
    dfd = @api.send 'VideoLibrary.GetTVShows', args
    dfd.then (data) =>
      @_result data, 'tvshows', 'tvshow', fn

  @tvshow: (id, options = {}, fn = null) =>
    debug 'tvshow', id, options
    args =
      tvshowid: id
      properties: options.properties || []
    dfd = @api.send 'VideoLibrary.GetTVShowDetails', args
    dfd.then (data) =>
      @_result data, 'tvshowdetails', 'tvshow', fn

  @episodes: (tvshowid = -1, season = -1, options = {}, fn = null) =>
    debug 'episodes', options
    args =
      properties: options.properties || []
      sort:       options.sort       || {}
      limits:     options.limits     || {}
    args.tvshowid = tvshowid if tvshowid >= 0
    args.season = season if season >= 0
    dfd = @api.send 'VideoLibrary.GetEpisodes', args
    dfd.then (data) =>
      @_result data, 'episodes', 'episodes', fn

  @episode: (id, options = {}, fn = null) =>
    debug 'episode', id, options
    args =
      episodeid: id
      properties: options.properties || [
        'title'
        'showtitle'
        'plot'
        'season'
        'episode'
        'thumbnail'
      ]
    dfd = @api.send 'VideoLibrary.GetEpisodeDetails', args
    dfd.then (data) =>
      @_result data, 'episodedetails', 'episode', fn

  @movies: (options = {}, fn = null) =>
    debug 'movies', options
    args =
      properties: options.properties || []
      sort:       options.sort       || {}
      limits:     options.limits     || {}
    dfd = @api.send 'VideoLibrary.GetMovies', args
    dfd.then (data) =>
      @_result data, 'movies', 'movies', fn

  @movie: (id, options = {}, fn = null) =>
    debug 'movie', id, options
    # Legacy: old versions didn't have options parameter
    if typeof options == 'function'
      fn = options
      options = null
    options = options || {}
    dfd = @api.send 'VideoLibrary.GetMovieDetails',
      movieid: id
      properties: options.properties || [
        'title'
        'year'
        'plotoutline'
        'plot'
        'thumbnail'
      ]
    dfd.then (data) =>
      @_result data, 'moviedetails', 'movie', fn

module.exports = Media
