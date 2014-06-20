MA.ApplicationController = Ember.ObjectController.extend
  selectedMovie: null
  movieToRecommend: null

  init: ->
    if !localStorage.getItem('beenHereBefore')
      @set('youtubeId', 'bRPQmaFQiwM')
      @set('movie_title', 'Movie Title')

  youtubeSrc: (->
    "//www.youtube.com/embed/#{@get('youtubeId')}?rel=0&controls=0&autoplay=1&loop=1&hd=1&showinfo=0&modestbranding=1&playlist=#{@get('youtubeId')}"
  ).property('youtubeId')
  youtubeId: "_Ls19O-9p3s" #The Matrix

  actions:
    query: (movie)->
      return unless movie

      @_switchTrailer(movie.value, movie.production_year)
      @get('store').find('movie', movie.value).then( (movie)=>
        @set('movieToRecommend', movie)
      )

    recommendationSelected: (movie)->
      @set('selectedMovie', { id: movie.id, value: movie.get('movie_title'), production_year: movie.get('production_year') })
      @_switchTrailer(movie.get('movie_title'), movie.get('production_year'))
      @get('store').find('movie', movie.id).then( (movie)=>
        @set('movieToRecommend', movie)
      )

  _switchTrailer: (title, year)->
    youtubeFeedURL = encodeURI("http://gdata.youtube.com/feeds/videos?vq=#{title} #{year} trailer&alt=json-in-script&results=1")
    $.ajax(
      url: youtubeFeedURL
      dataType: 'jsonp'
      success: ((response) =>
        youtubeId = response.feed.entry[0].id.$t.split("/")[5]
        @set('youtubeId', youtubeId)
      )
    )
