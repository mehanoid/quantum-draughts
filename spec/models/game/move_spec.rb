# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Move, type: :model do

  context 'king' do
    context 'zigzag beats' do
      let(:board) do
        Game::Board.from_s(<<~BOARD)
          . . . . . . . □
          . . . . . . ● .
          . . . . . . . .
          . . . . . . . .
          . . . ● . . . .
          . . . . . . . .
          . . . ● . . . .
          . . . . . . . .
        BOARD
      end

      it 'beats all of them' do
        new_board = Game::Move.new(board, %w[H8 F6 C3 E1], :white).perform

        expect(new_board.to_s).to eq <<~BOARD
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . □ . . .
        BOARD
      end

      it 'can not stop after first beating' do
        expect {
          Game::Move.new(board, %w[H8 F6], :white).perform
        }.to raise_error Game::InvalidMove
      end
    end
  end
end
