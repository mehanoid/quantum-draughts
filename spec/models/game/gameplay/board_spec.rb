# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Gameplay::Board do
  subject { described_class.new }

  it 'has 32 playable_cells' do
    expect(subject.playable_cells.size).to eq 32
  end

  describe '::populated' do
    subject { described_class.populated }

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

  describe '#cell_at' do
    it 'returns cell instance' do
      expect(subject.cell_at('A1').name).to eq 'A1'
      expect(subject.cell_at('A7').name).to eq 'A7'
      expect(subject.cell_at('F4').name).to eq 'F4'
      expect(subject.cell_at('H8').name).to eq 'H8'
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
    it 'returns one cell between the specified from bottom-left' do
      diagonal = subject.cells_between(subject.cell_at('E1'), subject.cell_at('G3'))
      expect(diagonal.map(&:name)).to eq %w[F2]
    end

    it 'returns all cells between the specified from bottom-left' do
      diagonal = subject.cells_between(subject.cell_at('B2'), subject.cell_at('G7'))
      expect(diagonal.map(&:name)).to eq %w[C3 D4 E5 F6]
    end

    it 'returns one cell on the same diagonal from bottom-right' do
      diagonal = subject.cells_between(subject.cell_at('C1'), subject.cell_at('A3'))
      expect(diagonal.map(&:name)).to eq %w[B2]
    end
  end

  describe '#update' do
    it 'removes draught at position' do
      board = Game::Gameplay::Board.from_s(<<~BOARD)
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
      new_board = subject.update('A1' => Game::Gameplay::Draught.new(id: 1, color: :white))

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
    context 'different boards' do
      let(:board1) { described_class.new(cells: { 'A1' => { c: 'w', id: 1 } }) }
      let(:board2) { described_class.new(cells: { 'A1' => { c: 'w', id: 2 } }) }

      it 'is not equal' do
        expect(board1).not_to eq board2
      end
    end

    context 'same boards' do
      let(:board1) { described_class.new(cells: { 'A1' => { c: 'w', id: 1 } }) }
      let(:board2) { described_class.new(cells: { 'A1' => { c: 'w', id: 1 } }) }

      it 'is equal' do
        expect(board1).to eq board2
      end
    end
  end
end
