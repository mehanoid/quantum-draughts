# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'matches#index'
  resources :matches, except: %i[update] do
    member do
      post :move
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
