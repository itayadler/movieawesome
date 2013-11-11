require 'recommendations'

class MovieSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :production_year, :movie_title, :rating, :id
  has_many :recommendations, key: 'recommendations', serializer: RecommendationSerializer

  def id
    object.node_id
  end

  def recommendations
    Recommendations.graph_related_by_movie(object.node_id)
  end
end
