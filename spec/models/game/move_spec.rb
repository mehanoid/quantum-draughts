# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Move, type: :model do
  context 'populated board' do
    let(:board) { Game::Board.new }
    before do
      board.populate!
    end

    it 'moves C3:D4' do
      Game::Move.new(board, %w[C3 D4]).perform!

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

    it 'raises error on too long move' do
      expect {
        Game::Move.new(board, %w[C3 E5]).perform!
      }.to raise_error Game::Move::InvalidMove
    end
  end

  context 'two draughts' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . ● . . . . .
        . ○ . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves to free cell' do
      Game::Move.new(board, %w[B2 A3]).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        ○ . ● . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'does not move to occupied cell' do
      expect {
        Game::Move.new(board, %w[B2 C3]).perform!
      }.to raise_error Game::Move::InvalidMove
    end

    it 'does not move from empty cell' do
      expect {
        Game::Move.new(board, %w[A3 B4]).perform!
      }.to raise_error Game::Move::InvalidMove
    end
  end

  context 'surrounded draught' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ○ . ○ . . . .
        . . ● . . . . .
        . ○ . ○ . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats draught if jump over it to top-right' do
      Game::Move.new(board, %w[C3 E5]).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . ○ . . . . . .
        . . . . . . . .
        . ○ . ○ . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats draught if jump over it to top-left' do
      Game::Move.new(board, %w[C3 A5]).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        ● . . . . . . .
        . . . ○ . . . .
        . . . . . . . .
        . ○ . ○ . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats draught if jump over it to top-right' do
      Game::Move.new(board, %w[C3 E1]).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ○ . ○ . . . .
        . . . . . . . .
        . ○ . . . . . .
        . . . . ● . . .
      BOARD
    end

    it 'beats draught if jump over it to top-right' do
      Game::Move.new(board, %w[C3 A1]).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ○ . ○ . . . .
        . . . . . . . .
        . . . ○ . . . .
        ● . . . . . . .
      BOARD
    end
  end
end
