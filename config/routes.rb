Mmdb::Application.routes.draw do
  match '/login' => 'sessions#new'
  match '/logout' => 'sessions#destroy'
  match '/integration-login' => 'sessions#integration_login',
    :as => :integration_login if Rails.env.test?

  resources :sessions, :only => [:new, :create, :destroy]

  match '/movies/new-from-imdb' => 'movies#new',
    :from_imdb => true, :as => :new_movie_from_imdb

  resources :movies do
    collection do
      post :scrape_info
    end
  end

  resources :people do
    resources :credits, :only => [:new, :create, :destroy]
  end

  root :to => 'movies#index'
end
