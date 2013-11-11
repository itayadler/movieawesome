class MovieIndexSerializer < ActiveModel::Serializer
  attributes :production_year, :id, :rating, :value

  def value
    object.movie_title
  end

  def id
    object.node_id
  end

end

