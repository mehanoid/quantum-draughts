# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::DraughtMoveStep do
  context 'populated board' do
    let(:match) {Match.new.init_boards}
    let(:game_play) {Game::Gameplay.new(match)}


    pending 'blah blah blah'
  end
end
