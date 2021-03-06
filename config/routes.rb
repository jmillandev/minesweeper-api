Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1, defaults: { format: :json } do
    resources :games, only: [:create]
    resources :flags, only: [:create]
    resources :explorer, only: [:create]
  end
end
