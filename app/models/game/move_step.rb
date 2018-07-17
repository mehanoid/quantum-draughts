# frozen_string_literal: true

module Game
  class MoveStep
    attr_accessor :from_cell, :to_cell, :current_player, :board

    # @param [Game::Board] board
    # @param [Array<String>] move_cells
    def initialize(board, move_cells, current_player = nil)
      @board          = board
      @params         = move_cells
      from, to        = @params
      @from_cell      = @board.cell_at(from)
      @to_cell        = @board.cell_at(to)
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
      return 'can not move back' unless valid_direction?
      if beaten_cells.present?
        return 'invalid beating' unless valid_beaten_cells_order?
        return 'can not beat draught of the same color' unless valid_beaten_draughts_color?
      else
        return 'invalid move distance' unless valid_move_distance?
      end
    end

    def beaten_cells
      @board.cells_between(from_cell, to_cell).select(&:occupied?)
    end

    def valid_beaten_draughts_color?
      beaten_cells.none? { |c| c.draught.color == from_cell.draught.color }
    end

    def valid_direction?
      raise 'abstract method'
    end

    def valid_beaten_cells_order?
      raise 'abstract method'
    end

    def valid_move_distance?
      raise 'abstract method'
    end

    class << self
      def build(board, move_cells, current_player = nil)
        from_cell = board.cell_at(move_cells.first)
        klass     =
          if from_cell.draught&.king?
            KingMoveStep
          else
            DraughtMoveStep
          end
        klass.new(board, move_cells, current_player)
      end
    end
  end
end
