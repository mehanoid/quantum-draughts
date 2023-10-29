# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay do
  context 'with populated board' do
    let(:match_turn) { Game::MatchTurn.new.init_boards }

    it 'does something' do
      skip('todo')
    end
  end
end
