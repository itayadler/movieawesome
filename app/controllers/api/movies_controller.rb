class Api::MoviesController < ApplicationController
  def index
    movie = {id: '1', name: 'The Matrix'}
    movies = [movie]
    render json: movies
  end

  def show
    movie = { movie: {
      id: '1', name: 'The Matrix',
      reco: [
          id: '2', name: 'The Matrix Reloaded',
          id: '3', name: 'The Matrix Revolutions'
        ]
      
    }}
    render json: movie
  end
end
