require 'ostruct'

class Recommendations

  def self.graph_related_by_movie(movie_node_id)
    #This query is heavily based on the Flow Rank Pattern https://github.com/tinkerpop/gremlin/wiki/Flow-Rank-Pattern
    script = <<-GREMLIN
      g.v(#{movie_node_id}).as('x').out.in
      .groupCount.cap().next()
      .sort{-it.value}[0..10].collect{ r = it.key.map.next(); r.put('rank', it.value); r }
    GREMLIN
    raw_result = $neo.execute_script(script)
    raw_result.reject { |result| result["node_id"] == movie_node_id.to_s }.map do |result|
      Recommendation.new(result["node_id"], result["rating"], result["movie_title"], result["production_year"], result["rank"])
    end
  end

end
