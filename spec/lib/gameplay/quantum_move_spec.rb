# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay::QuantumMove do
  let(:ruleset) { Gameplay::RussianRuleset }

  context 'with one draught' do
    let(:board) do
      Gameplay::Board.from_s(<<~BOARD)
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
      new_boards = described_class.new([board], [%w[D2 E3], %w[D2 C3]], :white, ruleset: ruleset).perform

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

  context 'with two draughts' do
    let(:board) do
      Gameplay::Board.from_s(<<~BOARD)
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
        described_class.new([board], [%w[D2 E3], %w[F2 E3]], :white, ruleset: ruleset).perform
      }.to raise_error Gameplay::InvalidMove
    end
  end

  context 'when king can beat one draught on both boards, and another only on one board' do
    let(:boards) do
      [<<~BOARD, <<~BOARD2].map { |b| Gameplay::Board.from_s(b) }
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . . . . . . . .
        . . . . ● . . .
        . . . □ . . . .
        . . . . . . . .
      BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . . . □ . . . .
        . . . . . . . .
      BOARD2
    end

    it 'beats both draughts on first board' do
      new_boards = described_class.new(boards, [%w[D2 F4 D6]], :white, ruleset: ruleset).perform

      expect(new_boards).to match_multiboard [<<~BOARD, <<~BOARD2]
        . . . . . . . .
        . . . . . . . .
        . . . □ . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . □ . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD2
    end

    it 'can not stop after beating first draught' do
      expect {
        described_class.new(boards, [%w[D2 F4]], :white, ruleset: ruleset).perform
      }.to raise_error Gameplay::InvalidMove
    end
  end

  context 'when draught can beat two draughts on one board but can not beat and stop on another' do
    let(:boards) do
      [<<~BOARD, <<~BOARD2].map { |b| Gameplay::Board.from_s(b) }
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . . . . . . . .
        . . . . ● . . .
        . . . ○ . . . .
        . . . . . . . .
      BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . ● .
        . . . ○ . . . .
        . . . . . . . .
      BOARD2
    end

    it 'beats both draughts on first board and does not move on second board' do
      new_boards = described_class.new(boards, [%w[D2 F4 D6]], :white, ruleset: ruleset).perform

      expect(new_boards).to match_multiboard [<<~BOARD, <<~BOARD2]
        . . . . . . . .
        . . . . . . . .
        . . . ○ . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . ● .
        . . . ○ . . . .
        . . . . . . . .
      BOARD2
    end

    it 'can not stop after beating first draught' do
      expect {
        described_class.new(boards, [%w[D2 F4]], :white, ruleset: ruleset).perform
      }.to raise_error Gameplay::InvalidMove
    end
  end

  context 'when can beat two draughts on first board and no one on another' do
    let(:boards) do
      [<<~BOARD, <<~BOARD2].map { |b| Gameplay::Board.from_s(b) }
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . . . . . . . .
        . . . . ● . . .
        . . . ○ . . . .
        . . . . . . . .
      BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . . . . . . . .
        . . . . . . . .
        . . . ○ . . . .
        . . . . . . . .
      BOARD2
    end

    it 'beats both draughts on first board' do
      new_boards = described_class.new(boards, [%w[D2 F4 D6]], :white, ruleset: ruleset).perform

      expect(new_boards).to match_multiboard [<<~BOARD, <<~BOARD2]
        . . . . . . . .
        . . . . . . . .
        . . . ○ . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . ● . . .
        . . . . . . . .
        . . . . . . . .
        . . . ○ . . . .
        . . . . . . . .
      BOARD2
    end
  end
end
