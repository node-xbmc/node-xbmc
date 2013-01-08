pubsub = require './PubSub'

class Media
  @mixin: (api) ->
    @api = api
    api.media = {}
    api.media[name] = method for name, method of @
    delete api.media.mixin

  @episode: (id) =>
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
      pubsub.emit 'api:episode', @api.scrub data.result.episodedetails

  @movies: (options = {}, fn = null) =>
    args =
      properties: options.properties || []
      sort:       options.sort       || {}
      limits:     options.limits     || {}
    dfd = @api.send 'VideoLibrary.GetMovies', args
    dfd.then (data) =>
      pubsub.emit 'api:movies', data.result.movies
      fn data if fn

  @movie: (id, fn = null) =>
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
      d = @api.scrub data.result.moviedetails
      pubsub.emit 'api:movie', d
      fn d if fn

module.exports = Media
