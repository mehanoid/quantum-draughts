# frozen_string_literal: true

class Match < ApplicationRecord
  enum current_player: {white: 0, black: 1}

  def init_boards
    board = Game::Board.new
    board.populate!
    self.boards = [board].map(&:as_json)
    save
    self
  end
end
