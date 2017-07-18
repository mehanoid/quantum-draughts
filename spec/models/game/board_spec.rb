# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Board, type: :model do
  subject { Game::Board.new }

  it 'has 64 cells' do
    expect(subject.cells.size).to eq 64
  end

  describe '#populate!' do
    before do
      subject.populate!
    end

    it 'has 12 white draughts' do
      draughts = subject.draughts.select(&:black?)
      expect(draughts.count).to eq 12
    end

    it 'has 12 black draughts' do
      draughts = subject.draughts.select(&:white?)
      expect(draughts.count).to eq 12
    end

    it 'matches initial state' do
      expect(subject.to_s).to eq <<~BOARD
        . ● . ● . ● . ●
        ● . ● . ● . ● .
        . ● . ● . ● . ●
        . . . . . . . .
        . . . . . . . .
        ○ . ○ . ○ . ○ .
        . ○ . ○ . ○ . ○
        ○ . ○ . ○ . ○ .
      BOARD
    end
  end
end
