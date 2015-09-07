Rails.application.routes.draw do

  # requires LOGIN before entering the interface
  root 'sessions#new'

  # manages User's session ( SIGN UP - LOGIN - LOGOUT )
  get '/signup' => 'users#new', as: :signup
  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy', as: :logout

  resources :clients, :users

  # Routes for Employees and everything involved
  namespace :employee do
    get '/home' => 'employees#index', as: :index
    get '/profile/:id' => 'employees#show', as: :profile
    get 'profile/:id/edit' => 'employees#edit', as: :edit_profile
    patch '/profile/:id' => 'employees#update', as: :update_profile
    get '/profile/checkpwd/:id' => 'employees#check_password'
    get '/surveys' => 'surveys#index', as: :surveys_all
    get '/surveys/filter' => 'surveys#filter', as: :surveys_filtered
  end

  # Routes for Leaders and everything involved
  namespace :leader do
    get '/home' => 'leaders#index', as: :index
  end
end
