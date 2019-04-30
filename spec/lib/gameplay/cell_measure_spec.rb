# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay::CellMeasure do
  def init_boards(data)
    data.map { |d| Gameplay::Types::Board.new(d) }
  end

  context 'all conflicting boards' do
    let(:boards) {
      init_boards(
        [
          { cells: { 'A1' => { c: 'w', id: 1 } } },
          { cells: { 'A1' => { c: 'w', id: 2 } } },
        ]
      )
    }

    it 'keeps one of two boards' do
      result = described_class.new(boards, 'A1').perform
      expect(result.length).to eq 1
    end
  end

  context 'draught vs empty cell' do
    let(:boards) {
      init_boards(
        [
          { cells: { 'A1' => { c: 'w', id: 1 } } },
          { cells: {} },
        ]
      )
    }

    it 'keeps one of two boards' do
      result = described_class.new(boards, 'A1').perform
      expect(result.length).to eq 1
    end
  end

  context 'same boards' do
    let(:boards) {
      init_boards(
        [
          { cells: { 'A1' => { c: 'w', id: 1 } } },
          { cells: { 'A1' => { c: 'w', id: 1 } } },
        ]
      )
    }

    it 'keeps both boards' do
      result = described_class.new(boards, 'A1').perform
      expect(result.length).to eq 2
    end
  end
end
