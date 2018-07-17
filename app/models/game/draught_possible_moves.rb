# frozen_string_literal: true

module Game
  class DraughtPossibleMoves
    include Memery

    attr_reader :board, :cell_name, :current_player

    # @param [Game::Board] board
    # @param [Array<String>] move_cells
    def initialize(board, cell_name, current_player)
      @board          = board
      @cell_name      = cell_name
      @current_player = current_player
    end

    # @return [Array<String>]
    def possible_moves
      possible_move_steps.select(&method(:valid_move?)).map { |step| step.to_cell.name }
    end

    memoize def beat_move_steps
      possible_move_steps.select(&:beat?)
    end

    memoize def possible_move_steps
      board.playable_cells.map do |cell|
        MoveStep.build(board, [cell_name, cell.name], current_player)
      end.select(&:valid?)
    end

    memoize def all_beat_move_steps
      self.class.all_beat_move_steps(board, current_player)
    end

    class << self
      def all_beat_move_steps(board, player)
        all_possible_move_steps(board, player).select(&:beat?)
      end

      def all_possible_move_steps(board, player)
        from_cells = board.occupied_cells.select { |c| c.draught.color == player }
        from_cells.flat_map do |cell|
          new(board, cell.name, player).possible_move_steps
        end
      end
    end

    private

      def valid_move?(move_step)
        move_step.valid? && (all_beat_move_steps.blank? || move_step.beat?)
      end
  end
end
