# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  devise_for :users
  get 'users/current'

  get 'about' => 'pages#front'

  resource :profile, only: :update

  namespace :game do
    resources :matches, only: %i[show create index] do
      member do
        post :join
        post :move
      end
    end
    resources :match_turns, only: %i[show]
  end

  mount SwitchUserPage::Engine, at: 'switch_user_page' if defined? SwitchUserPage::Engine
end
