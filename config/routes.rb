# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'matches#index'
  resources :matches do
    member do
      get :possible_moves
      post :move
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
