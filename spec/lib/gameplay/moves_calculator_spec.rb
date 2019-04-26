# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay::MovesCalculator do
  let(:ruleset) { Gameplay::RussianRuleset }

  context 'populated board' do
    let(:board) { Gameplay::Board.populated }

    describe 'possible moves' do
      it 'return array of resulting cells' do
        possible_moves = described_class.new(board, 'C3', :white, ruleset: ruleset).possible_moves
        expect(possible_moves).to match_array %w[B4 D4]
      end
    end
  end

  context 'draught can beat' do
    let(:board) do
      Gameplay::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . ● . . . . .
        . ○ . . . . ○ .
        . . . . . . . .
      BOARD
    end

    describe 'possible moves' do
      it 'should beat' do
        possible_moves = described_class.new(board, 'B2', :white, ruleset: ruleset).possible_moves
        expect(possible_moves).to match_array ['D4']
      end

      it 'can not move if another draught can beat' do
        possible_moves = described_class.new(board, 'G2', :white, ruleset: ruleset).possible_moves
        expect(possible_moves).to be_empty
      end
    end
  end

  context 'draught can beat multiple times' do
    let(:board) do
      Gameplay::Board.from_s(<<~BOARD)
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

    describe 'possible_move_chains' do
      it 'should beat with chained move' do
        chain_cells = described_class.new(board, 'B2', :white, ruleset: ruleset).possible_move_chains_cell_names
        expect(chain_cells).to match_array [%w[D4 B6], %w[D4 F6]]
      end
    end
  end

  context 'king can beat in opposite directions' do
    let(:board) do
      Gameplay::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . ● .
        . . . . . . . .
        . . . . . . . .
        . . . □ . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . . . . .
      BOARD
    end

    describe 'possible_move_chains' do
      it 'can beat one of the draughts' do
        chain_cells = described_class.new(board, 'D4', :white, ruleset: ruleset).possible_move_chains_cell_names
        expect(chain_cells).to match_array [%w[A1], %w[H8]]
      end
    end
  end
end
