Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  # static
  get  '/help', to: 'static_pages#help'
  get  '/about', to: 'static_pages#about'
  get  '/home', to: 'static_pages#home'
  get  '/contact', to: 'static_pages#contact'

  # login/register
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # resources
  resources :users
end
