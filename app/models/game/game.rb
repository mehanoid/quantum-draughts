# frozen_string_literal: true

module Game
  class Game
    attr_accessor :board

    # @param [Match] match
    def initialize(match)
      @match = match
      @board = Board.new(match.boards.first)
    end

    def move(params)
      Move.new(board, params).perform!
      save!
    end

    def save!
      @match.update! boards: [board].map(&:as_json)
    end

    private
  end
end
