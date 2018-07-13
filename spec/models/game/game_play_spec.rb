# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Move, type: :model do
  context 'populated board' do
    let(:match) {Match.new.init_boards}
    let(:game_play) {Game::GamePlay.new(match)}


    describe 'possible moves' do
      it 'return array of resulting cells' do
        expect(game_play.possible_moves('C3').map(&:name)).to match_array ['B4', 'D4']
      end
    end
  end
end
