Rails.application.routes.draw do

  # requires LOGIN before entering the interface
  root 'sessions#new'

  # manages User's session ( SIGN UP - LOGIN - LOGOUT )
  get '/signup' => 'users#new', as: :signup
  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy', as: :logout

  get '/users/profile/:id' => 'users#show', as: :user_profile
  post '/users/profile/checkpwd/:id' => 'users#check_password'
  get '/users/profile/:id/edit' => 'users#edit', as: :edit_profile
  patch '/users/profile/:id' => 'users#update', as: :update_profile

  resources :clients, :users

  # Routes for Employees and everything involved
  namespace :employee do
    ## profile
    get '/home' => 'employees#index', as: :index
    #get '/profile/:id' => 'employees#show', as: :profile
    #get 'profile/:id/edit' => 'employees#edit', as: :edit_profile
    #patch '/profile/:id' => 'employees#update', as: :update_profile

    ## surveys
    get '/surveys' => 'surveys#index', as: :surveys_all
    get '/surveys/filter' => 'surveys#filter', as: :surveys_filtered
    get '/surveys/typed_list_surveys/:type' => 'surveys#index_typed_surveys', as: :typed_surveys
    get '/surveys/:id' => 'surveys#show', as: :show_survey
    post '/surveys/:id/submit' => 'surveys#submit_survey', as: :submit_survey
  end

  # Routes for Leaders and everything involved
  namespace :leader do
    ## profile
    get '/home' => 'leaders#index', as: :index

    ## surveys
    get '/surveys' => 'surveys#index', as: :surveys_all
    get '/surveys/filter' => 'surveys#filter', as: :surveys_filtered
    get '/surveys/:id' => 'surveys#show', as: :show_survey
    post '/surveys/:id/submit' => 'surveys#submit_survey', as: :submit_survey
  end
end
