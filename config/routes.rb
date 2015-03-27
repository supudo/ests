Rails.application.routes.draw do

  resources :users

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
