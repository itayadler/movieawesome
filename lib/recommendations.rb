require 'ostruct'

class Recommendations

  def self.graph_related_by_movie(movie_node_id)
    #This query is heavily based on the Flow Rank Pattern https://github.com/tinkerpop/gremlin/wiki/Flow-Rank-Pattern
    script = <<-GREMLIN
      g.v(#{movie_node_id}).as('x').out.in
      .groupCount.cap().next()
      .sort{-it.value}[0..11].collect{ [movie_title: it.key.movie_title, rank: it.value, production_year: it.key.production_year, id: it.key.id] }
    GREMLIN
    raw_result = $neo.execute_script(script)
    raw_result.map do |result|
      Recommendation.new(result["id"], result["rating"], result["movie_title"], result["production_year"], result["rank"])
    end
  end

end
