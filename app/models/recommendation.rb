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

  def image_url
    "http://api.movieposterdb.com/image?title=#{CGI.escape(@movie_title + " " + @production_year.to_s)}&api_key=demo&secret=175d21687261&width=150"
  end

end

