MA.Movie = DS.Model.extend
  movie_title: DS.attr('string')
  production_year: DS.attr('number')
  rating: DS.attr('string')
  recommendations: DS.hasMany('recommendation')

MA.Recommendation = DS.Model.extend
  movie_title: DS.attr('string')
  production_year: DS.attr('string')
  rating: DS.attr('string')
  rank: DS.attr('string')
  movie: DS.belongsTo('movie') 
