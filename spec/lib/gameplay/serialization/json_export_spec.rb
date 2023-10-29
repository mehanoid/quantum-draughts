# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay::Serialization::JsonExport do
  context 'with two boards' do
    let(:boards) do
      [Gameplay::Types::Board.from_s(<<~BOARD), Gameplay::Types::Board.from_s(<<~BOARD2)]
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
      result = described_class.new(boards).as_json
      expect(result[:weights]).to contain_exactly(1, 1)

      draught1 = result[:draughts].find { |c| c[:cell] == 'B4' }
      draught2 = result[:draughts].find { |c| c[:cell] == 'D2' }
      expect(draught1[:king]).to be false
      expect(draught1[:boards]).to contain_exactly(0, 1)
      expect(draught2[:king]).to be true
      expect(draught2[:boards]).to contain_exactly(0)
    end
  end
end
