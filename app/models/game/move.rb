# frozen_string_literal: true

module Game
  class Move
    class InvalidMove < StandardError; end
    attr_accessor :from_cell, :to_cell, :current_player

    # @param [Game::Board] board
    # @param [Array<String>] move_cells
    def initialize(board, move_cells, current_player = nil)
      @board = board
      @params = move_cells
      from, to = @params
      @from_cell = @board.cell_at(from)
      @to_cell = @board.cell_at(to)
      @current_player = current_player
    end

    def perform!
      validate!

      from_cell.draught, to_cell.draught = to_cell.draught, from_cell.draught
      beaten_cells.each do |c|
        c.draught = nil
      end
    end

    def valid?
      validate!
      true
    rescue InvalidMove
      false
    end

    def validate!
      raise InvalidMove, 'source is empty' unless from_cell.occupied?
      raise InvalidMove, "other player's turn" unless current_player == from_cell.draught.color
      raise InvalidMove, 'destination is not playable' unless to_cell.playable
      raise InvalidMove, 'destination is occupied' unless to_cell.empty?
      raise InvalidMove, 'cells are not on the same diagonal' unless from_cell.same_diagonal?(to_cell)
      if beaten_cells.present?
        #   TODO
        raise InvalidMove, 'invalid beating' unless valid_beaten_cells_order?
        raise InvalidMove, 'can not beat draught of the same color' unless valid_beaten_draughts_color?
      else
        raise InvalidMove, 'cells are not adjacent' unless from_cell.adjacent?(to_cell)
      end
    end

    # Beaten cells should be placed alternating with the free ones,
    # so that the draught can jump over them
    def valid_beaten_cells_order?
      cells_between = @board.cells_between(from_cell, to_cell)
      return false unless cells_between.first.occupied? && cells_between.last.occupied?
      cells_between.each_with_index.all? do |cell, index|
        (index.even? && cell.occupied?) || (index.odd? && cell.empty?)
      end
    end

    def valid_beaten_draughts_color?
      beaten_cells.none? { |c| c.draught.color == from_cell.draught.color }
    end

    def beaten_cells
      @board.cells_between(from_cell, to_cell).select { |c| c.draught.present? }
    end
  end
end
