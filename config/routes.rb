Rails.application.routes.draw do

  resources :users
  resources :projects
  resources :estimates
  resources :estimatessection
  resources :estimatesline
  resources :estimatesassumption
  resources :clients
  resources :permissions
  resources :commenthistory
  resources :requesthistory
  resources :technologies
  resources :project_statuses
  resources :estimate_importer

  resources :estimate_importer do
    collection { post :import }
  end

  resources :estimatesline do
    member do
      get :moveup, :movedown, :destroy, :create
    end
    get :autocomplete_estimatesline_line, :on => :collection
  end

  resources :estimatesassumption do
    member do
      get :destroy, :create
    end
  end

  resources :estimatessheet do
    member do
      get :destroy, :create
    end
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

  resources :estimates do
    get :autocomplete_estimate_title, :on => :collection
  end

  get 'about/new'
  get 'help/new'
  get 'about/new'
  root 'login#index'

  get 'signup' => 'users#new'
  get 'login/index'
  post 'login' => 'login#signin'
  get 'logout' => 'login#destroy'
  delete 'logout' => 'login#destroy'

  get 'dashboard' => 'dashboard#index'

end
