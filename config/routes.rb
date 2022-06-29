Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'
  # this is the controller/application_controller
  root 'static_pages#home'
end
