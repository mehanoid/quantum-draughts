# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  devise_for :users

  get 'about' => 'pages#front'

  namespace :game do
    resources :matches, only: %i[show create index] do
      member do
        post :join
        post :move
      end
    end
    resource :current_player, only: %i[show update]
    resources :match_turns, only: %i[show]
  end

  mount SwitchUserPage::Engine, at: 'switch_user_page' if defined? SwitchUserPage::Engine
end
