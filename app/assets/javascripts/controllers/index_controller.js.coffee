MA.IndexController = Ember.ObjectController.extend
  selectedMovie: null
  movieToRecommend: null
  actions:
    query: ->
      movie = @get('selectedMovie')
      return unless movie
      @get('store').find('movie', movie.id).then( (movie)=>
        @set('movieToRecommend', movie)
      )
