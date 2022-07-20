Rails.application.routes.draw do
  namespace :v1 do
    resources :transfers, only: [:create]
  end

  resources :webhooks, only: [:create]
end
