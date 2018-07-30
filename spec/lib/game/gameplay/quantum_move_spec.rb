# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Gameplay::QuantumMove do

  context 'one draught' do
    let(:board) do
      Game::Gameplay::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . ○ . . . .
        . . . . . . . .
      BOARD
    end

    it 'moves one step right and left' do
      new_boards = described_class.new([board], [%w[D2 E3], %w[D2 C3]], :white).perform

      expect(new_boards.map(&:to_s)).to match_array [<<~BOARD, <<~BOARD2]
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ○ . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . ○ . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD2
    end
  end

  context 'two draughts' do
    let(:board) do
      Game::Gameplay::Board.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . ○ . ○ . .
        . . . . . . . .
      BOARD
    end

    it 'can not move both draughts at once' do
      expect {
        described_class.new([board], [%w[D2 E3], %w[F2 E3]], :white).perform
      }.to raise_error Game::Gameplay::InvalidMove
    end
  end
end
