# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Gameplay::QuantumMovesCalculator do
  context 'populated board' do
    let(:board) do
      Game::Gameplay::Board.from_s(<<~BOARD)
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
        chains = described_class.valid_possible_move_chains([board], :white)
        expect(chains).to match_array(
          [
            { beat: true, cells: %w[B2 D4 B6] },
            { beat: true, cells: %w[B2 D4 F6] },
          ]
        )
      end
    end
  end

  context 'king can beat one draught on both boards, and another only on one board' do
    let(:boards) do
      [<<~BOARD, <<~BOARD2].map { |b| Game::Gameplay::Board.from_s(b) }
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
      chains = described_class.valid_possible_move_chains(boards, :white)
      expect(chains).to eq([beat: true, cells: %w[D2 F4 B8]])
    end
  end
end
