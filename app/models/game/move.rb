# frozen_string_literal: true

module Game
  class Move
    class InvalidMove < StandardError; end
    attr_accessor :from_cell, :to_cell

    # @param [Game::Board] board
    # @param [Array] params
    def initialize(board, params)
      @board = board
      @params = params
      from, to = @params
      @from_cell = @board.cell_at(from)
      @to_cell = @board.cell_at(to)
    end

    def perform!
      raise InvalidMove unless valid?

      from_cell.draught, to_cell.draught = to_cell.draught, from_cell.draught
    end

    private

    def valid?
      to_cell.playable && to_cell.draught.blank? && from_cell.ajacent?(to_cell)
    end
  end
end
