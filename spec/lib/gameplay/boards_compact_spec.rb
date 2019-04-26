# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameplay::BoardsCompact do
  def init_boards(data)
    data.map { |d| Gameplay::Board.new(d) }
  end

  context 'different boards' do
    let(:boards) {
      init_boards(
        [
          { cells: { 'A1' => { c: 'w', id: 1 } } },
          { cells: { 'A1' => { c: 'w', id: 2 } } },
        ]
      )
    }

    it 'keeps both boards' do
      result = described_class.new(boards).perform
      expect(result.length).to eq 2
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

    it 'keeps one of boards' do
      result = described_class.new(boards).perform
      expect(result.length).to eq 1
    end
  end
end
