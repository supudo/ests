Rails.application.routes.draw do

  resources :users
  resources :projects
  resources :estimates
  resources :estimatessection
  resources :estimatesassumption
  resources :estimatessheet
  resources :clients
  resources :permissions
  resources :commenthistory
  resources :requesthistory
  resources :technologies
  resources :project_statuses
  resources :estimate_importer
  resources :positions
  resources :estimate_exporter
  resources :currencies
  resources :engagement_models
  resources :rates_prices

  get 'rates/update_positions', as: 'update_positions'
  resources :rates

  resources :currencies do
    member do
      post :update_rates
    end
  end

  resources :estimates do
    get :autocomplete_estimate_title, :on => :collection
  end

  resources :estimatesline do
    member do
      get :show, :moveup, :movedown, :destroy, :create, :update
    end
    get :autocomplete_estimatesline_line, :on => :collection
  end

  resources :estimate_importer do
    collection { post :import }
  end

  resources :clients do
    get :autocomplete_client_title, :on => :collection
  end

  resources :projects do
    get :autocomplete_project_title, :on => :collection
  end

  resources :users do
    get :autocomplete_user_searchname, :on => :collection
  end

  get 'about/new'
  get 'help/new'
  get 'about/new'
  root 'login#index'

  get 'collections' => 'collections#index'

  post 'estimatessection/update' => 'estimatessection#update'
  post 'estimatessection/destroy' => 'estimatessection#destroy'
  patch 'rates_prices/update' => 'rates_prices#update'

  get 'signup' => 'users#new'
  get 'login/index'
  post 'login' => 'login#signin'
  get 'logout' => 'login#destroy'
  delete 'logout' => 'login#destroy'

  get 'dashboard' => 'dashboard#index'

end
