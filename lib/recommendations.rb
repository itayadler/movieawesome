class Recommendations

  def self.graph_related_by_movie(movie)
    #This query is heavily based on the Flow Rank Pattern https://github.com/tinkerpop/gremlin/wiki/Flow-Rank-Pattern
    cluster_id = cluster.id
    item = cluster.rep_item
    stuff_cat_id = item.stuff_cat_id
    script = <<-GREMLIN
      v = g.idx('node_auto_index')[[neoid_unique_id: 'ItemCluster:#{cluster_id}']]
      v.in.out
      .groupCount.cap().next()
      .sort{-it.value}[0..11].collect{ [id: it.key.title_id, rank: it.value] }
    GREMLIN
    raw_result = Neoid.db.execute_script(script)
    #[load_clusters(raw_result), raw_result]
  end

  def self.load_clusters(raw_result)
    #Then we map the results into cluster_ids, sorted by most similar cluster
    ids = raw_result.map { |item| item["id"] }
    #Fetching the clusters from the database. We also sort them by the order of the raw_result, since the result set
    #we will get from the database, will have a different order.
    recommendations = ItemCluster.where(id: ids).sort_by do |cluster|
      raw_result.find { |item| item["id"] == cluster.id }["rank"]
    end.reverse
  end

end
