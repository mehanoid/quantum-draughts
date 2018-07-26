# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::DraughtMoveStep do
  context 'populated board' do
    let(:match_turn) {Game::MatchTurn.new.init_boards}
    let(:game_play) {Game::Gameplay.new(match_turn)}


    pending 'blah blah blah'
  end
end
