# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay do
  let(:match_turn) { Game::MatchTurn.new.init_boards }
  let(:moves_params) { [%w[C3 D4]] }
  let(:ruleset) { Gameplay::EnglishRuleset }
  let(:move) { instance_double(Gameplay::QuantumMove) }

  describe '::move' do
    let(:move_result) { described_class.move(match_turn, moves_params, ruleset) }

    it 'returns :black as the next turn player' do
      expect(move_result[:next_turn][:player]).to eq :black
    end

    it 'returns the performed move' do
      expect(move_result[:move]).to eq [{ beat: false, cells: %w[C3 D4] }]
    end

    it 'includes :draughts in the next turn boards' do
      expect(move_result[:next_turn][:boards]).to include(:draughts)
    end
  end
end
