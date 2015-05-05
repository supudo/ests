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

  get 'rates/rates_update_positions', as: 'rates_update_positions'
  resources :rates

  resources :currencies do
    member do
      post :update_rates
    end
  end

  get 'estimatesline/lines_update_positions', as: 'lines_update_positions'
  resources :estimatesline do
    member do
      get :show, :moveup, :movedown, :destroy, :create, :update
    end
    get :autocomplete_estimatesline_line, :on => :collection
  end

  resources :estimate_importer do
    collection { post :import }
  end

  get 'about/new'
  get 'help/new'
  get 'about/new'
  root 'login#index'

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
