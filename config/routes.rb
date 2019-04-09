# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'game/matches#index'

  devise_for :users
  get 'users/current'

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

  mount SwitchUserPage::Engine, at: 'switch_user_page' if defined? SwitchUserPage::Engine
end
