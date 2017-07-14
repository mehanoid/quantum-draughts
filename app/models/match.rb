# frozen_string_literal: true

class Match < ApplicationRecord
  def init_boards
    board = Board.new
    board.populate!
    self.boards = [board].map(&:as_json)
    save
  end
end
