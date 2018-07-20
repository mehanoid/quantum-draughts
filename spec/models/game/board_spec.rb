# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Board, type: :model do
  subject { Game::Board.new }

  it 'has 64 cells' do
    expect(subject.cells.size).to eq 64
  end

  describe '::populated' do
    subject { Game::Board.populated }

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

  describe '#diagonal_through_cells' do
    it 'returns cells on the same diagonal from bottom-left' do
      diagonal = subject.diagonal_through_cells(subject.cell_at('E1'), subject.cell_at('G3'))
      expect(diagonal.map(&:name)).to eq %w[E1 F2 G3 H4]
    end

    it 'returns cells on the same diagonal from bottom-right' do
      diagonal = subject.diagonal_through_cells(subject.cell_at('C1'), subject.cell_at('A3'))
      expect(diagonal.map(&:name)).to eq %w[C1 B2 A3]
    end
  end

  describe '#cells_between' do
    it 'returns cells between the specified from bottom-left' do
      diagonal = subject.cells_between(subject.cell_at('E1'), subject.cell_at('G3'))
      expect(diagonal.map(&:name)).to eq %w[F2]
    end

    it 'returns cells on the same diagonal from bottom-right' do
      diagonal = subject.cells_between(subject.cell_at('C1'), subject.cell_at('A3'))
      expect(diagonal.map(&:name)).to eq %w[B2]
    end
  end

  describe '#==' do
    context 'different boards' do
      let(:board1) { Game::Board.new({ cells: { 'A1' => { c: 'w', id: 1 } } }) }
      let(:board2) { Game::Board.new({ cells: { 'A1' => { c: 'w', id: 2 } } }) }

      it 'is not equal' do
        expect(board1).not_to eq board2
      end
    end

    context 'same boards' do
      let(:board1) { Game::Board.new({ cells: { 'A1' => { c: 'w', id: 1 } } }) }
      let(:board2) { Game::Board.new({ cells: { 'A1' => { c: 'w', id: 1 } } }) }

      it 'is equal' do
        expect(board1).to eq board2
      end
    end
  end
end
