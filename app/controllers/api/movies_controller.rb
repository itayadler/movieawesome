class Api::MoviesController < ApplicationController
  def index
    movies = MovieNode.fuzzy_search(movie_title: params[:q]).first(10)
    render json: movies, each_serializer: MovieIndexSerializer, root: false
  end

  def show
    movie = MovieNode.where(movie_title: params[:id]).first
    render json: movie, serializer: MovieSerializer
  end
end
