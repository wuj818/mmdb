Mmdb::Application.routes.draw do
  match '/login' => 'sessions#new'
  match '/logout' => 'sessions#destroy', :via => :delete
  match '/integration-login' => 'sessions#integration_login',
    :as => :integration_login if Rails.env.test?

  resources :sessions, :only => [:new, :create, :destroy]

  match '/movies/new-from-imdb' => 'movies#new',
    :from_imdb => true, :as => :new_movie_from_imdb

  match 'movies/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'movies#index'
  match 'movies/query/:q' => 'movies#index', :as => :formatted_search_movies

  resources :movies do
    collection do
      post :scrape_info
      get :search
    end
  end

  match 'people/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'people#index'
  match 'people/query/:q' => 'people#index', :as => :formatted_search_people

  resources :people, :except => [:new, :create] do
    resources :credits, :only => [:new, :create, :destroy]
    collection do
      get :search
    end
  end

  match 'genres/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'genres#index'
  match 'genres/query/:q' => 'genres#index', :as => :formatted_search_genres
  match 'genres/:id/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'genres#show'

  resources :genres, :only => [:index, :show] do
    collection do
      get :search
    end
  end

  match '/stats' => 'pages#stats'

  root :to => 'pages#stats'
end
