class Recommendations

  def self.graph_related_by_movie(movie_node_id)
    #This query is heavily based on the Flow Rank Pattern https://github.com/tinkerpop/gremlin/wiki/Flow-Rank-Pattern
    script = <<-GREMLIN
      g.v(#{movie_node_id}).as('x').out.in
      .groupCount.cap().next()
      .sort{-it.value}[0..11].collect{ [name: it.key.movie_title, rank: it.value, year: it.key.production_year] }
    GREMLIN
    raw_result = Neoid.db.execute_script(script)
  end

end
