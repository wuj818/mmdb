Mmdb::Application.routes.draw do
  resources :sessions, :only => [:new, :create, :destroy]
  resources :movies do
    collection do
      post :scrape_info
    end
  end

  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy'
  match '/integration-login', :to => 'sessions#integration_login',
    :as => :integration_login if Rails.env.test?

  root :to => 'movies#index'
end
