require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'convert_processes#index'
  resources :convert_processes
  
  mount Sidekiq::Web => '/sidekiq'
end
