# frozen_string_literal: true

module Game
  class Game
    def initialize(match)
      @match = match
      @board = Board.new(match.boards.first)
    end

    def move!(params)
      Move.new(@board, params).perform!
      save!
    end

    def save!
      @match.update! boards: [@board].map(&:as_json)
    end

    private
  end
end
