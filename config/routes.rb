Rails.application.routes.draw do
  root 'static_pages#home'
  # static
  get  '/help', to: 'static_pages#help'
  get  '/about', to: 'static_pages#about'
  get  '/home', to: 'static_pages#home'
  get  '/contact', to: 'static_pages#contact'

  # user
  get '/signup', to: 'users#new'

  # resources
  resources :users
end
