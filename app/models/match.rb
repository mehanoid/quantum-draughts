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

  def collapse_boards!
    self.boards = boards.first(1)
    save
  end

  def to_s
    boards.map do |b|
      board = Game::Board.new(b)
      "#{board.weight}\n#{board}\n"
    end
  end
end
