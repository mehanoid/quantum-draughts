# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay::BoardsCollapse do
  def init_boards(data)
    data.map { |d| Gameplay::Types::Board.new(d) }
  end

  context 'with all conflicting boards' do
    let(:boards) {
      init_boards(
        [
          { cells: { 'A1' => { c: 'w', id: 1 } } },
          { cells: { 'A1' => { c: 'w', id: 2 } } },
        ]
      )
    }

    it 'keeps one of two boards' do
      result = described_class.new(boards).perform
      expect(result.length).to eq 1
    end
  end

  context 'with draught vs empty cell' do
    let(:boards) {
      init_boards(
        [
          { cells: { 'A1' => { c: 'w', id: 1 } } },
          { cells: {} },
        ]
      )
    }

    it 'keeps both boards' do
      result = described_class.new(boards).perform
      expect(result.length).to eq 2
    end
  end

  context 'with same boards' do
    let(:boards) {
      init_boards(
        [
          { cells: { 'A1' => { c: 'w', id: 1 } } },
          { cells: { 'A1' => { c: 'w', id: 1 } } },
        ]
      )
    }

    it 'keeps both boards' do
      result = described_class.new(boards).perform
      expect(result.length).to eq 2
    end
  end
end
