Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'
  get '/integration-login', to: 'sessions#integration_login',
    as: 'integration_login' if Rails.env.test?

  resources :sessions, only: [:new, :create, :destroy]

  get '/admin-controls', to: 'pages#admin_controls',
    as: 'admin_controls_path'

  delete '/clear-cache', to: 'pages#clear_cache',
    as: 'clear_cache'

  get '/movies/new-from-imdb', to: 'movies#new',
    from_imdb: true, as: 'new_movie_from_imdb'

  post '/movies/scrape-info', to: 'movies#scrape_info', as: 'scrape_info'

  get 'movies/sort/:sort/order/:order(/page/:page)(/query/:q)', to: 'movies#index'
  get 'movies(/query/:q)', to: 'movies#index',
    as: 'formatted_search_movies'

  resources :movies do
    collection do
      post :scrape_info
      get :search
      get :perfect
    end

    member do
      get :keywords
    end
  end

  get 'people/sort/:sort/order/:order(/page/:page)(/query/:q)', to: 'people#index'
  get 'people(/query/:q)', to: 'people#index',
    as: 'formatted_search_people'

  resources :people, except: [:new, :create] do
    resources :credits, only: [:new, :create, :destroy]

    collection do
      get :search
    end

    member do
      get :keywords
      get :charts
    end
  end

  [:decades, :years].each do |type|
    get "#{type}/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)", to: "#{type}#index"
    get "#{type}/:id/sort/:sort/order/:order(/page/:page)(/query/:q)", to: "#{type}#show"
    get "#{type}(/total-at-least/:minimum)(/query/:q)", to: "#{type}#index",
      as: "formatted_search_#{type}"

    resources type, only: [:index, :show] do
      collection do
        get :search
      end
    end
  end

  resources :item_lists, path: 'lists' do
    member do
      put :reorder
    end

    resources :listings, only: [:new, :create, :destroy]
  end

  get 'tags/search', to: 'tags#search'
  get ':type/sort/:sort/order/:order(/total-at-least/:minimum)(/page/:page)(/query/:q)', to: 'tags#index'
  get ':type/:id/sort/:sort/order/:order(/page/:page)(/query/:q)', to: 'tags#show'
  get ':type(/total-at-least/:minimum)(/query/:q)', to: 'tags#index',
    as: 'formatted_search_tags'

  [:genres, :keywords, :languages, :countries].each do |type|
    get ':type', to: 'tags#index', as: type.to_s, type: type
    get ':type/:id', to: 'tags#show'
  end

  resources :tags, only: [:index, :show] do
    collection do
      get :search
    end
  end

  root to: 'pages#main'
end
