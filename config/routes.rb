Mmdb::Application.routes.draw do
  match '/login' => 'sessions#new'
  match '/logout' => 'sessions#destroy', :via => :delete
  match '/integration-login' => 'sessions#integration_login',
    :as => :integration_login if Rails.env.test?

  resources :sessions, :only => [:new, :create, :destroy]

  match '/movies/new-from-imdb' => 'movies#new', :from_imdb => true, :as => :new_movie_from_imdb

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

  match 'tags/search' => 'tags#search'
  match ':type/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)' => 'tags#index'
  match ':type/:id/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'tags#show'
  match ':type/(/total-at-least/:minimum)(/query/:q)' => 'tags#index', :as => :formatted_search_tags

  [:genres, :keywords, :languages, :countries].each do |type|
    match ':type' => 'tags#index', :as => :"#{type}"
    match ':type/stats' => 'tags#stats', :as => :"formatted_stats_#{type}", :type => type
    match ':type/:id' => 'tags#show'
  end

  resources :tags, :only => [:index, :show] do
    collection do
      get :search
      get :stats
    end

    member do
      get :stats
    end
  end

  match '/stats' => 'pages#stats'

  root :to => 'pages#main'
end
