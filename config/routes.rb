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

  get 'casestudies/export_casestudy_pdf', as: 'export_casestudy_pdf'
  resources :casestudies

  post 'casestudiesitems/add_overview', as: 'add_overview'
  patch 'casestudiesitems/update_overview', as: 'update_overview'
  delete 'casestudiesitems/destroy_overview', as: 'destroy_overview'
  get 'casestudiesitems/moveup_overview', as: 'moveup_overview'
  get 'casestudiesitems/movedown_overview', as: 'movedown_overview'

  post 'casestudiesitems/add_challenge', as: 'add_challenge'
  patch 'casestudiesitems/update_challenge', as: 'update_challenge'
  delete 'casestudiesitems/destroy_challenge', as: 'destroy_challenge'
  get 'casestudiesitems/moveup_challenge', as: 'moveup_challenge'
  get 'casestudiesitems/movedown_challenge', as: 'movedown_challenge'

  post 'casestudiesitems/add_solution', as: 'add_solution'
  patch 'casestudiesitems/update_solution', as: 'update_solution'
  delete 'casestudiesitems/destroy_solution', as: 'destroy_solution'
  get 'casestudiesitems/moveup_solution', as: 'moveup_solution'
  get 'casestudiesitems/movedown_solution', as: 'movedown_solution'

  post 'casestudiesitems/add_technology', as: 'add_technology'
  patch 'casestudiesitems/update_technology', as: 'update_technology'
  delete 'casestudiesitems/destroy_technology', as: 'destroy_technology'
  get 'casestudiesitems/moveup_technology', as: 'moveup_technology'
  get 'casestudiesitems/movedown_technology', as: 'movedown_technology'

  post 'casestudiesitems/add_link', as: 'add_link'
  patch 'casestudiesitems/update_link', as: 'update_link'
  delete 'casestudiesitems/destroy_link', as: 'destroy_link'
  get 'casestudiesitems/moveup_link', as: 'moveup_link'
  get 'casestudiesitems/movedown_link', as: 'movedown_link'

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

  resources :users_permission

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
