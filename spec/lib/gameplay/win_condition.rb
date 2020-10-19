# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay::WinCondition do
  let(:ruleset) { Gameplay::RussianRuleset }

  context 'each player can move' do
    let(:boards) do
      [
        Gameplay::Types::Board.from_s(<<~BOARD),
          . . . . . . . .
          . . . . . . . .
          . . . ● . . . .
          . . . . ○ . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
        BOARD
      ]
    end

    it 'returns finished false' do
      result = described_class.new(boards, :black, ruleset: ruleset).perform

      expect(result[:finished]).to eq false
    end
  end

  context 'black player has no draughts' do
    let(:boards) do
      [
        Gameplay::Types::Board.from_s(<<~BOARD),
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . ○ . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
        BOARD
      ]
    end

    it 'returns finished true' do
      result = described_class.new(boards, :black, ruleset: ruleset).perform

      expect(result[:finished]).to eq true
    end

    it 'marks white player as winner' do
      result = described_class.new(boards, :black, ruleset: ruleset).perform

      expect(result[:winner]).to eq :white
    end
  end

  context 'black player can not move' do
    let(:boards) do
      [
        Gameplay::Types::Board.from_s(<<~BOARD),
          . . . . . . . .
          . . . . . . . .
          . . . . . . . ●
          . . . . . . ○ .
          . . . . . ○ . .
          . . . . . . . .
          . . . . . . . .
          . . . . . . . .
        BOARD
      ]
    end

    it 'returns finished true' do
      result = described_class.new(boards, :black, ruleset: ruleset).perform

      expect(result[:finished]).to eq true
    end

    it 'marks white player as winner' do
      result = described_class.new(boards, :black, ruleset: ruleset).perform

      expect(result[:winner]).to eq :white
    end
  end
end
