MA.Router.map ()->
  @resource('movies', ->
    @route('show', path: '/:movie_id')
  )

MA.MoviesShowRoute = Ember.Route.extend
  model: (params)->
    @get('store').find('movie', params.movie_id)

  setupController: (controller, movie)->
    controller.set('model', movie)
