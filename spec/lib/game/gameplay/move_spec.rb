# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Gameplay::Move do

  context 'man draughts' do
    let(:board) do
      Game::Gameplay::Board.from_s(<<~BOARD)
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
      new_board = described_class.new(board, %w[D2 E3], :white).perform

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
      new_board = described_class.new(board, %w[D2 C3], :white).perform

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
      Game::Gameplay::Board.from_s(<<~BOARD)
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
      new_board = described_class.new(board, %w[D6 B8], :white).perform

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
      new_board = described_class.new(board, %w[D6 F8 H6 C1], :white).perform

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
      Game::Gameplay::Board.from_s(<<~BOARD)
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
      new_board = described_class.new(board, %w[E5 C7], :white).perform

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
        Game::Gameplay::Board.from_s(<<~BOARD)
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
        new_board = described_class.new(board, %w[H8 F6 C3 E1], :white).perform

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
          described_class.new(board, %w[H8 F6], :white).perform
        }.to raise_error Game::Gameplay::InvalidMove
      end

      pending 'can not move on to avoid third beating' do
        expect {
          described_class.new(board, %w[H8 F6 B2], :white).perform
        }.to raise_error Game::Gameplay::InvalidMove
      end
    end

    context 'can beat in opposite directions' do
      let(:board) do
        Game::Gameplay::Board.from_s(<<~BOARD)
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

      pending 'can beat one of them' do
        new_board = described_class.new(board, %w[D4 A1], :white).perform

        expect(new_board.to_s).to eq <<~BOARD
          . . . . . . . .
          . . . . . . ● .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          □ . . . . . . .
        BOARD
      end

      pending 'can not beat one draught two times' do
        expect {
          described_class.new(board, %w[D4 A1 H8], :white).perform
        }.to raise_error Game::Gameplay::InvalidMove
      end
    end
  end
end
