MA.IndexController = Ember.ObjectController.extend
  selectedMovie: null
  movieToRecommend: null
  needs: ["application"]
  actions:
    query: (movie)->
      return unless movie

      @_switchTrailer(movie.value, movie.production_year)
      @get('store').find('movie', movie.id).then( (movie)=>
        @set('movieToRecommend', movie)
      )

    recommendationSelected: (movie)->
      @set('selectedMovie', { id: movie.id, value: movie.get('movie_title'), production_year: movie.get('production_year') })
      @_switchTrailer(movie.get('movie_title'), movie.get('production_year'))
      @get('store').find('movie', movie.id).then( (movie)=>
        @set('movieToRecommend', movie)
      )

  _switchTrailer: (title, year)->
    $.ajax(
      url: "http://gdata.youtube.com/feeds/videos?vq=#{title} #{year} trailer&alt=json-in-script&results=1"
      dataType: 'jsonp'
      success: ((response) =>
        youtubeId = response.feed.entry[0].id.$t.split("/")[5]
        @get('controllers.application').set('youtubeId', youtubeId)
      )
    )
