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
      get :stats
    end
  end

  match 'people/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'people#index'
  match 'people/query/:q' => 'people#index', :as => :formatted_search_people

  resources :people, :except => [:new, :create] do
    resources :credits, :only => [:new, :create, :destroy]

    collection do
      get :search
      get :stats
    end
  end

  match 'genres/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)' => 'genres#index'
  match 'genres(/total-at-least/:minimum)(/query/:q)' => 'genres#index', :as => :formatted_search_genres
  match 'genres/:id/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'genres#show'

  resources :genres, :only => [:index, :show] do
    collection do
      get :search
      get :stats
    end
  end

  match 'keywords/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)' => 'keywords#index'
  match 'keywords(/total-at-least/:minimum)(/query/:q)' => 'keywords#index', :as => :formatted_search_keywords
  match 'keywords/:id/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'keywords#show'

  resources :keywords, :only => [:index, :show] do
    collection do
      get :search
      get :stats
    end
  end

  match 'languages/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)' => 'languages#index'
  match 'languages(/total-at-least/:minimum)(/query/:q)' => 'languages#index', :as => :formatted_search_languages
  match 'languages/:id/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'languages#show'

  resources :languages, :only => [:index, :show] do
    collection do
      get :search
      get :stats
    end
  end

  match 'countries/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)' => 'countries#index'
  match 'countries(/total-at-least/:minimum)(/query/:q)' => 'countries#index', :as => :formatted_search_countries
  match 'countries/:id/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'countries#show'

  resources :countries, :only => [:index, :show] do
    collection do
      get :search
      get :stats
    end
  end

  match '/stats' => 'pages#stats'

  root :to => 'pages#main'
end
