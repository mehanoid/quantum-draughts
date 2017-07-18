require 'rails_helper'

RSpec.describe Game::Move, type: :model do
  let(:board) { Game::Board.new }

  context 'populated board' do
    before do
      board.populate!
    end

    it 'moves C3:D4' do
      Game::Move.new(board, ['C3', 'D4']).perform!

      expect(board.to_s).to eq <<~BOARD
        . ● . ● . ● . ●
        ● . ● . ● . ● .
        . ● . ● . ● . ●
        . . . . . . . .
        . . . ○ . . . .
        ○ . . . ○ . ○ .
        . ○ . ○ . ○ . ○
        ○ . ○ . ○ . ○ .
      BOARD
    end

    it 'raises error on invalid move' do
      expect {
        Game::Move.new(board, ['C3', 'E5']).perform!
      }.to raise_error Game::Move::InvalidMove
    end
  end
end
