# frozen_string_literal: true

module Game
  class DraughtMoveStep
    attr_accessor :from_cell, :to_cell, :current_player, :board

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
      @board
    end

    def valid?
      error.blank?
    end

    def beat?
      beaten_cells.present?
    end

    def validate!
      raise InvalidMove, error unless valid?
    end

    def error
      return 'source is empty' unless from_cell.occupied?
      return "other player's turn" unless current_player == from_cell.draught.color
      return 'destination is not playable' unless to_cell.playable
      return 'destination is occupied' unless to_cell.empty?
      return 'cells are not on the same diagonal' unless from_cell.same_diagonal?(to_cell)
      if beaten_cells.present?
        return 'invalid beating' unless valid_beaten_cells_order?
        return 'can not beat draught of the same color' unless valid_beaten_draughts_color?
      else
        return 'cells are not adjacent' unless from_cell.adjacent?(to_cell)
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
