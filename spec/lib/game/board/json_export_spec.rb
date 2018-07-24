# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::Board::JsonExport do
  context 'two boards' do
    let(:boards) do
      [Game::Board.from_s(<<~BOARD), Game::Board.from_s(<<~BOARD2)]
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . . . . .
        . . . □ . . . .
        . . . . . . . .
      BOARD
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . . . . . . . .
        . ● . . . . . .
        . . . . □ . . .
        . . . . . . . .
        . . . . . . . .
      BOARD2
    end

    it 'creates json' do
      result = Game::Board::JsonExport.new(boards).as_json
      expect(result[:weights]).to match_array [1, 1]

      draught1 = result[:draughts].find { |c| c[:cell] == 'B4' }
      draught2 = result[:draughts].find { |c| c[:cell] == 'D2' }
      expect(draught1[:king]).to be false
      expect(draught1[:boards]).to match_array [0, 1]
      expect(draught2[:king]).to be true
      expect(draught2[:boards]).to match_array [0]
    end
  end
end
