# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay do
  context 'populated board' do
    let(:match_turn) { Game::MatchTurn.new.init_boards }
  end
end
