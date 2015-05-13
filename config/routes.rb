Rails.application.routes.draw do

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
  resources :estimate_exporter
  resources :currencies
  resources :engagement_models
  resources :about
  resources :help
  resources :casestudies

  post 'rates_prices/complex_add', as: 'complex_add'
  resources :rates_prices

  get 'positions/positions_update_complexity', as: 'positions_update_complexity'
  resources :positions

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

  get 'users/users_update_positions', as: 'users_update_positions'
  resources :users

  resources :estimate_importer do
    collection { post :import }
  end

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

  get 'registration/registration_update_positions', as: 'registration_update_positions'
  resources :registration

end
