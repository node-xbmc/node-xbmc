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

  @episode: (id) =>
    debug 'episode', id
    dfd = @api.send 'VideoLibrary.GetEpisodeDetails',
      episodeid: id
      properties: [
        'title'
        'showtitle'
        'plot'
        'season'
        'episode'
        'thumbnail'
      ]
    dfd.then (data) =>
      @_result data, 'episodedetails', 'episode'

  @movies: (options = {}, fn = null) =>
    debug 'movies', options
    args =
      properties: options.properties || []
      sort:       options.sort       || {}
      limits:     options.limits     || {}
    dfd = @api.send 'VideoLibrary.GetMovies', args
    dfd.then (data) =>
      @_result data, 'movies', 'movies', fn

  @movie: (id, fn = null) =>
    debug 'movie', id
    dfd = @api.send 'VideoLibrary.GetMovieDetails',
      movieid: id
      properties: [
        'title'
        'year'
        'plotoutline'
        'plot'
        'thumbnail'
      ]
    dfd.then (data) =>
      @_result data, 'moviedetails', 'movie', fn

module.exports = Media
