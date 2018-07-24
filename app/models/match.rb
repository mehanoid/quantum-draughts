# frozen_string_literal: true

class Match < ApplicationRecord
  enum current_player: { white: 0, black: 1 }

  def init_boards
    board = Game::Board.populated
    self.boards = Game::Board::JsonExport.new([board]).as_json
    save
    self
  end

  def board_instances
    Game::Board::JsonImport.new(boards).boards
  end

  def to_s
    board_instances.map do |b|
      "#{b.weight}\n#{b}\n"
    end
  end
end
