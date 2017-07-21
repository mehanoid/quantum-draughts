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
      validate!

      from_cell.draught, to_cell.draught = to_cell.draught, from_cell.draught
      beaten_cells.each do |c|
        c.draught = nil
      end
    end

    def valid?
      validate && true
    rescue InvalidMove
      false
    end

    def validate!
      raise InvalidMove, 'source is empty' unless from_cell.draught
      raise InvalidMove, 'destination is not playable' unless to_cell.playable
      raise InvalidMove, 'destination is occupied' unless to_cell.draught.blank?
      raise InvalidMove, 'cells are not on the same diagonal' unless from_cell.same_diagonal?(to_cell)
      if beaten_cells.present?
      #   TODO
      else
        raise InvalidMove, 'cells are not adjacent' unless from_cell.adjacent?(to_cell)
      end
    end

    def beaten_cells
      @board.cells_between(from_cell, to_cell).select { |c| c.draught.present? }
    end
  end
end
