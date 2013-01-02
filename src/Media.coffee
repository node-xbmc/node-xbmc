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

  @movie: (id) =>
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
      pubsub.emit 'api:movie', @api.scrub data.result.moviedetails

module.exports = Media
