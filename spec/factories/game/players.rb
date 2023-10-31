# frozen_string_literal: true

FactoryBot.define do
  factory :game_player, class: 'Game::Player' do
    user { nil }
    displaying_name { 'MyString' }
  end
end
