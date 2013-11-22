MA.ApplicationView = Ember.View.extend
  timeoutId: null

  mouseMove: (->
    Ember.run.debounce(@, (->
      clearTimeout(@timeoutId)
      @timeoutId = null
      @$('.main').animate(opacity: 1)
      @timeoutId = setTimeout( (=>
        @timeoutId = null
        @$('.main').animate(opacity: 0)
      ), 5000)
    ), 500))

