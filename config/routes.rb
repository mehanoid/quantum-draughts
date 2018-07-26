# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'game/matches#index'

  namespace :game do
    resources :matches, except: %i[edit update] do
      member do
        post :move
      end
    end
  end
end
