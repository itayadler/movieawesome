class Recommendation
  include ActiveModel::Serializers::JSON
  
  attr_accessor :production_year, :movie_title, :rating, :id, :rank

  def initialize(id, rating, movie_title, production_year, rank)
    @id = id
    @rating = rating
    @movie_title = movie_title
    @production_year = production_year
    @rank = rank
  end

end

