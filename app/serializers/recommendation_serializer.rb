class RecommendationSerializer < ActiveModel::Serializer
  attributes :production_year, :movie_title, :rating, :id, :rank, :image_url
end
