Rails.application.routes.draw do
  resources :microposts
  resources :users
  # this is the controller/application_controller
  root 'users#index'
end
