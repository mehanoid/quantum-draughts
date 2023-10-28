# frozen_string_literal: true

FactoryBot.define do
  factory :game_match, class: 'Game::Match' do
    after(:create) do |match, _evaluator|
      match.match_turns.build.init_boards
    end
  end
end
