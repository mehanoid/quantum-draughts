# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay::QuantumBoardMovesCalculator do
  context 'with populated board' do
    let(:board) do
      Gameplay::Types::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . ● . ● . . .
        . . . . . . . .
        . . ● . . . . .
        . ○ . . . . ○ .
        . . . . . . . .
      BOARD
    end

    describe '::valid_possible_move_chains' do
      it 'return array of resulting cells' do
        chains = described_class.new([board], :white, ruleset: Gameplay::RussianRuleset).valid_possible_move_chains
        expect(chains).to match_array(
          [
            { beat: true, cells: %w[B2 D4 B6] },
            { beat: true, cells: %w[B2 D4 F6] },
          ]
        )
      end
    end
  end

  context 'when king can beat one draught on both boards, and another only on one board' do
    let(:boards) do
      [<<~BOARD, <<~BOARD2].map { |b| Gameplay::Types::Board.from_s(b) }
        . . . . . . . .
        . . ● . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . . . □ . . . .
        . . . . . . . .
      BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . . . □ . . . .
        . . . . . . . .
      BOARD2
    end

    it 'can not stop after beating first draught' do
      chains = described_class.new(boards, :white, ruleset: Gameplay::RussianRuleset).valid_possible_move_chains
      expect(chains).to eq([beat: true, cells: %w[D2 F4 B8]])
    end
  end
end
