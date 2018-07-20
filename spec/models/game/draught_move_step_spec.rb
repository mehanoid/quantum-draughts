# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::DraughtMoveStep, type: :model do
  context 'populated board' do
    let(:board) { Game::Board.populated }

    it 'moves C3:D4' do
      new_board = Game::DraughtMoveStep.new(board, %w[C3 D4], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
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
        Game::DraughtMoveStep.new(board, %w[C3 E5], :white).perform
      }.to raise_error Game::InvalidMove, /invalid move distance/
    end

    it 'raises error if draught belongs to other player' do
      expect {
        Game::DraughtMoveStep.new(board, %w[C3 E5], :black).perform
      }.to raise_error Game::InvalidMove, "other player's turn"
    end
  end

  context 'white draught' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ○ . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves forward' do
      new_board = Game::DraughtMoveStep.new(board, %w[B2 C3], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . ○ . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'does not move back' do
      expect {
        Game::DraughtMoveStep.new(board, %w[B2 A1], :white).perform
      }.to raise_error Game::InvalidMove, /back/
    end
  end

  context 'black draught' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . ● . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves forward' do
      new_board = Game::DraughtMoveStep.new(board, %w[C3 B2], :black).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'does not move back' do
      expect {
        Game::DraughtMoveStep.new(board, %w[C3 D4], :black).perform
      }.to raise_error Game::InvalidMove, /back/
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

    it 'does not move to occupied cell' do
      expect {
        Game::DraughtMoveStep.new(board, %w[B2 C3], :white).perform
      }.to raise_error Game::InvalidMove, /occupied/
    end

    it 'does not move from empty cell' do
      expect {
        Game::DraughtMoveStep.new(board, %w[A3 B4], :white).perform
      }.to raise_error Game::InvalidMove, /empty/
    end
  end

  context 'two draughts of the same color' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . ○ . . . . .
        . ○ . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'does not beat draught of the same color' do
      expect {
        Game::DraughtMoveStep.new(board, %w[B2 D4], :white).perform
      }.to raise_error Game::InvalidMove, 'can not beat draught of the same color'
    end
  end

  context 'surrounded draught' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . ● . . . .
        . . ○ . . . . .
        . ● . ● . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats draught if jump over it to top-right' do
      new_board = Game::DraughtMoveStep.new(board, %w[C3 E5], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ○ . . .
        . ● . . . . . .
        . . . . . . . .
        . ● . ● . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats draught if jump over it to top-left' do
      new_board = Game::DraughtMoveStep.new(board, %w[C3 A5], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        ○ . . . . . . .
        . . . ● . . . .
        . . . . . . . .
        . ● . ● . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats draught if jump over it to top-right' do
      new_board = Game::DraughtMoveStep.new(board, %w[C3 E1], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . ● . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . ○ . . .
      BOARD
    end

    it 'beats draught if jump over it to top-right' do
      new_board = Game::DraughtMoveStep.new(board, %w[C3 A1], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . ● . . . .
        . . . . . . . .
        . . . ● . . . .
        ○ . . . . . . .
      BOARD
    end

    it 'does not beat with too long move' do
      expect {
        Game::DraughtMoveStep.new(board, %w[C3 F6], :white).perform
      }.to raise_error Game::InvalidMove, 'invalid beating'
    end
  end

  context 'near edge line' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . ○ . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'becomes white king' do
      new_board = Game::DraughtMoveStep.new(board, %w[C7 B8], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . □ . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'becomes black king' do
      new_board = Game::DraughtMoveStep.new(board, %w[B2 C1], :black).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . ○ . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . ■ . . . . .
      BOARD
    end
  end
end
