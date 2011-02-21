Mmdb::Application.routes.draw do
  get '/login' => 'sessions#new'
  delete '/logout' => 'sessions#destroy'
  get '/integration-login' => 'sessions#integration_login',
    :as => :integration_login if Rails.env.test?

  resources :sessions, :only => [:new, :create, :destroy]

  delete '/clear-cache' => 'pages#clear_cache',
    :as => :clear_cache

  get '/movies/new-from-imdb' => 'movies#new',
    :from_imdb => true, :as => :new_movie_from_imdb

  post '/movies/scrape-info' => 'movies#scrape_info', :as => :scrape_info

  get 'movies/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'movies#index'
  get 'movies(/query/:q)' => 'movies#index',
    :as => :formatted_search_movies

  resources :movies do
    collection do
      post :scrape_info
      get :search
      get :stats
    end

    member do
      get :keywords
    end
  end

  get 'people/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'people#index'
  get 'people(/query/:q)' => 'people#index',
    :as => :formatted_search_people

  resources :people, :except => [:new, :create] do
    resources :credits, :only => [:new, :create, :destroy]

    collection do
      get :search
      get :stats
    end

    member do
      get :keywords
      get :graphs
    end
  end

  [:decades, :years].each do |type|
    get "#{type}/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)" => "#{type}#index"
    get "#{type}/:id/sort/:sort/order/:order(/page/:page)(/query/:q)" => "#{type}#show"
    get "#{type}(/total-at-least/:minimum)(/query/:q)" => "#{type}#index",
      :as => :"formatted_search_#{type}"

    resources type, :only => [:index, :show] do
      collection do
        get :search
        get :stats
      end

      member do
        get :stats
      end
    end
  end

  resources :item_lists, :path => :lists do
    member do
      put :reorder
    end

    resources :listings, :only => [:new, :create, :destroy]
  end

  get '/stats' => 'pages#main'

  get 'tags/search' => 'tags#search'
  get ':type/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)' => 'tags#index'
  get ':type/:id/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'tags#show'
  get ':type(/total-at-least/:minimum)(/query/:q)' => 'tags#index',
    :as => :formatted_search_tags

  [:genres, :keywords, :languages, :countries].each do |type|
    get ':type' => 'tags#index', :as => :"#{type}", :type => type
    get ':type/stats' => 'tags#stats', :as => :"formatted_stats_#{type}", :type => type
    get ':type/:id' => 'tags#show'
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

  root :to => 'pages#main'
end
