MA.ApplicationController = Ember.ObjectController.extend
  youtubeSrc: (->
    "//www.youtube.com/embed/#{@get('youtubeId')}?rel=0&controls=0&autoplay=1&loop=1&hd=1&showinfo=0&modestbranding=1"
  ).property('youtubeId')
  youtubeId: "_Ls19O-9p3s" #The Matrix
