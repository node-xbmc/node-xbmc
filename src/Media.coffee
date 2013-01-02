class Media
  @mixin: (api) ->
    @api = api
    api.media = {}
    api.media[name] = method for name, method of @
    delete api.media.mixin

  @episode: (id) => do TODO

  @movie: (id)   => do TODO

module.exports = Media
