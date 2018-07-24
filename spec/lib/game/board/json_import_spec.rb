# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Board::JsonImport do
  let(:json) {
    {
      weights:  [1, 4],
      draughts: [
        { cell: 'A1', id: 1, king: false, boards: [0] },
        { cell: 'B8', id: 13, king: true, boards: [1] },
      ],
    }.deep_stringify_keys
  }

  it 'sets boards weights' do
    boards = Game::Board::JsonImport.new(json).boards

    expect(boards.first.weight).to eq 1
    expect(boards.last.weight).to eq 4
  end

  it 'sets boards data' do
    boards = Game::Board::JsonImport.new(json).boards
    expect(boards.map(&:to_s)).to match_array [<<~BOARD, <<~BOARD2]
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      ○ . . . . . . .
    BOARD
      . ■ . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
    BOARD2
  end
end
