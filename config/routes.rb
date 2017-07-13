Rails.application.routes.draw do
  root to: 'matches#index'
  resources :matches
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
