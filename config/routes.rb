# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'game/matches#index'

  namespace :game do
    resources :matches, only: %i[show create] do
      collection do
        get :index, to: redirect('/', status: 302)
      end
      member do
        post :join
        post :move
      end
    end
    resources :match_turns, only: %i[show]
  end
end
