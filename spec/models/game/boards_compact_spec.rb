# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::BoardsCompact, type: :model do
  def init_boards(data)
    data.map { |d| Game::Board.new(d) }
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
      result = Game::BoardsCompact.new(boards).perform
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
      result = Game::BoardsCompact.new(boards).perform
      expect(result.length).to eq 1
    end
  end
end
