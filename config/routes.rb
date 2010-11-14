Mmdb::Application.routes.draw do
  match '/login' => 'sessions#new', :via => :get
  match '/logout' => 'sessions#destroy', :via => :delete
  match '/integration-login' => 'sessions#integration_login',
    :as => :integration_login, :via => :get if Rails.env.test?

  resources :sessions, :only => [:new, :create, :destroy]

  match '/movies/new-from-imdb' => 'movies#new',
    :from_imdb => true, :as => :new_movie_from_imdb, :via => :get

  match 'movies/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'movies#index', :via => :get
  match 'movies(/query/:q)' => 'movies#index',
    :as => :formatted_search_movies, :via => :get

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

  match 'people/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'people#index', :via => :get
  match 'people(/query/:q)' => 'people#index',
    :as => :formatted_search_people, :via => :get

  resources :people, :except => [:new, :create] do
    resources :credits, :only => [:new, :create, :destroy]

    collection do
      get :search
      get :stats
    end

    member do
      get :keywords
    end
  end

  [:decades, :years].each do |type|
    match "#{type}/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)" => "#{type}#index", :via => :get
    match "#{type}/:id/sort/:sort/order/:order(/page/:page)(/query/:q)" => "#{type}#show", :via => :get
    match "#{type}(/total-at-least/:minimum)(/query/:q)" => "#{type}#index",
      :as => :"formatted_search_#{type}", :via => :get

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

  match '/stats' => 'pages#main', :via => :get

  match 'tags/search' => 'tags#search', :via => :get
  match ':type/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)' => 'tags#index', :via => :get
  match ':type/:id/sort/:sort/order/:order(/page/:page)(/query/:q)' => 'tags#show', :via => :get
  match ':type(/total-at-least/:minimum)(/query/:q)' => 'tags#index',
    :as => :formatted_search_tags, :via => :get

  [:genres, :keywords, :languages, :countries].each do |type|
    match ':type' => 'tags#index', :as => :"#{type}", :via => :get
    match ':type/stats' => 'tags#stats', :as => :"formatted_stats_#{type}", :type => type, :via => :get
    match ':type/:id' => 'tags#show', :via => :get
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

  root :to => 'pages#main', :via => :get
end
