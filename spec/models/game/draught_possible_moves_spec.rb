# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::DraughtPossibleMoves, type: :model do
  context 'populated board' do
    let(:board) { Game::Board.new }
    before do
      board.populate!
    end

    describe 'possible moves' do
      it 'return array of resulting cells' do
        possible_moves = Game::DraughtPossibleMoves.new(board, 'C3', :white).possible_moves
        expect(possible_moves).to match_array ['B4', 'D4']
      end
    end
  end

  context 'draught can beat' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
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
        possible_moves = Game::DraughtPossibleMoves.new(board, 'B2', :white).possible_moves
        expect(possible_moves).to match_array ['D4']
      end

      it 'can not move if another draught can beat' do
        possible_moves = Game::DraughtPossibleMoves.new(board, 'G2', :white).possible_moves
        expect(possible_moves).to be_empty
      end
    end
  end
end
