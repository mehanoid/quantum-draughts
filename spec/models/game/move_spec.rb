# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Move do

  context 'man draughts' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . . . . .
        . . . ○ . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves one step right' do
      new_board = Game::Move.new(board, %w[D2 E3], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . ○ . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves one step towards black draught' do
      new_board = Game::Move.new(board, %w[D2 C3], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . . . . . .
        . . ○ . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end
  end

  context 'man becoming king' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . ● . ● . ● .
        . . . ○ . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . ● . . . .
        . . . . . . . .
      BOARD
    end

    it 'beats to left' do
      new_board = Game::Move.new(board, %w[D6 B8], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . □ . . . . . .
        . . . . ● . ● .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . ● . . . .
        . . . . . . . .
      BOARD
    end

    it 'continues beating after becoming king' do
      new_board = Game::Move.new(board, %w[D6 F8 H6 C1], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . ● . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . □ . . . . .
      BOARD
    end
  end


  context 'two draughts can beat' do
    let(:board) do
      Game::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . ● . . . .
        . . . . ○ . . .
        . . . . . . . .
        . . . . . . . .
        . . . ● . . . .
        . . ○ . . . . .
      BOARD
    end

    it 'does not prevent second draught to move' do
      new_board = Game::Move.new(board, %w[E5 C7], :white).perform

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . ○ . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . ● . . . .
        . . ○ . . . . .
      BOARD
    end
  end

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
