MA.MoviesShowController = Ember.ObjectController.extend(
  
  # the initial value of the `search` property
  search: ""
  title: ""
  actions:
    query: ->
      
      # the current value of the text field
      #query = @get("search")
      #@transitionToRoute "search",
      #query: query

)
