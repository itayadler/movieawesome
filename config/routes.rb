Movieawesome::Application.routes.draw do
  root :to => 'application#index'
  namespace :api do
    resources :movies, only: [:index, :show]
  end
end
