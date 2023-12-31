# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay::Types::Board do
  subject(:board) { described_class.new }

  it 'has 32 playable_cells' do
    expect(board.playable_cells.size).to eq 32
  end

  describe '::populated' do
    subject(:board) { described_class.populated }

    it 'has 12 white draughts' do
      draughts = board.draughts.select(&:black?)
      expect(draughts.count).to eq 12
    end

    it 'has 12 black draughts' do
      draughts = board.draughts.select(&:white?)
      expect(draughts.count).to eq 12
    end

    it 'matches initial state' do
      expect(board.to_s).to eq <<~BOARD
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

  describe '#cell_at' do
    it 'returns cell instance' do
      expect(board.cell_at('A1').name).to eq 'A1'
      expect(board.cell_at('A7').name).to eq 'A7'
      expect(board.cell_at('F4').name).to eq 'F4'
      expect(board.cell_at('H8').name).to eq 'H8'
    end
  end

  describe '#diagonals_through_cell' do
    it 'returns cells on the same diagonal for cell' do
      diagonal = board.diagonals_through_cell(board.cell_at('E5'))
      expect(diagonal.map(&:name)).to match_array %w[F6 G7 H8 D4 C3 B2 A1 D6 C7 B8 F4 G3 H2]
    end

    it 'returns cells in diagonals of specified length' do
      diagonal = board.diagonals_through_cell(board.cell_at('E5'), 2)
      expect(diagonal.map(&:name)).to match_array %w[F6 G7 D4 C3 D6 C7 F4 G3]
    end
  end

  describe '#cells_between' do
    it 'returns one cell between the specified from bottom-left' do
      diagonal = board.cells_between(board.cell_at('E1'), board.cell_at('G3'))
      expect(diagonal.map(&:name)).to eq %w[F2]
    end

    it 'returns all cells between the specified from bottom-left' do
      diagonal = board.cells_between(board.cell_at('B2'), board.cell_at('G7'))
      expect(diagonal.map(&:name)).to eq %w[C3 D4 E5 F6]
    end

    it 'returns one cell on the same diagonal from bottom-right' do
      diagonal = board.cells_between(board.cell_at('C1'), board.cell_at('A3'))
      expect(diagonal.map(&:name)).to eq %w[B2]
    end
  end

  describe '#update' do
    it 'removes draught at position' do
      board = described_class.from_s(<<~BOARD)
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ○ . . . . . .
        . . . . . . . .
      BOARD

      new_board = board.update('B2' => nil)

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
      BOARD
    end

    it 'adds draught at position' do
      new_board = board.update('A1' => Gameplay::Types::Draught.new(id: 1, color: :white))

      expect(new_board.to_s).to eq <<~BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        ○ . . . . . . .
      BOARD
    end
  end

  describe '#==' do
    context 'with different boards' do
      let(:board) { described_class.new(cells: { 'A1' => { c: 'w', id: 1 } }) }
      let(:other_board) { described_class.new(cells: { 'A1' => { c: 'w', id: 2 } }) }

      it 'is not equal' do
        expect(board).not_to eq other_board
      end
    end

    context 'with same boards' do
      let(:board) { described_class.new(cells: { 'A1' => { c: 'w', id: 1 } }) }
      let(:other_board) { described_class.new(cells: { 'A1' => { c: 'w', id: 1 } }) }

      it 'is equal' do
        expect(board).to eq other_board
      end
    end
  end
end
