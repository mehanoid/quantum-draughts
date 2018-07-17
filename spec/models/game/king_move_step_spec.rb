# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::KingMoveStep, type: :model do

  context 'white king' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . □ . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves one step top right' do
      Game::KingMoveStep.new(board, %w[D4 E5], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . □ . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves long distance top right' do
      Game::KingMoveStep.new(board, %w[D4 H8], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . □
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves one step top left' do
      Game::KingMoveStep.new(board, %w[D4 C5], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . □ . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves long distance top left' do
      Game::KingMoveStep.new(board, %w[D4 A7], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        □ . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves one step down right' do
      Game::KingMoveStep.new(board, %w[D4 E3], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . □ . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves long distance down right' do
      Game::KingMoveStep.new(board, %w[D4 G1], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . □ .
      BOARD
    end

    it 'moves one step down left' do
      Game::KingMoveStep.new(board, %w[D4 C3], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . □ . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves long distance down left' do
      Game::KingMoveStep.new(board, %w[D4 A1], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        □ . . . . . . .
      BOARD
    end

    it 'dows not move horizontally one step top right' do
      expect {
        Game::KingMoveStep.new(board, %w[D4 B4], :white).perform!
      }.to raise_error /not on the same diagonal/
    end
  end

  context 'king with another draughts' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . ■ . . . . . .
        . . □ . . . . .
        . . . ● . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats top right and stops after draught' do
      Game::KingMoveStep.new(board, %w[C3 F6], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . □ . .
        . . . . . . . .
        . ■ . . . . . .
        . . . . . . . .
        . . . ● . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats top right and stops in some distance' do
      Game::KingMoveStep.new(board, %w[C3 H8], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . □
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ■ . . . . . .
        . . . . . . . .
        . . . ● . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats another king' do
      Game::KingMoveStep.new(board, %w[C3 A5], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        □ . . . ● . . .
        . . . . . . . .
        . . . . . . . .
        . . . ● . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats down right' do
      Game::KingMoveStep.new(board, %w[C3 E1], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . ■ . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . □ . . .
      BOARD
    end
  end

  context 'multiple beats at once' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . □
        . . . . . . ● .
        . . . . . . . .
        . . . . ● . . .
        . . . . . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats all of them' do
      Game::KingMoveStep.new(board, %w[H8 A1], :white).perform!

      expect(board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        □ . . . . . . .
      BOARD
    end
  end

  context 'draughts on adjacent cells' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . □
        . . . . . . ● .
        . . . . . ● . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'can not beat them' do

      expect {
        Game::KingMoveStep.new(board, %w[H8 E5], :white).perform!
      }.to raise_error /invalid beating/
    end
  end
end
