# frozen_string_literal: true

module Game
  class PossibleMoves
    include Memery

    attr_reader :board, :cell_name, :current_player

    # @param board [Game::Board]
    # @param move_cells [Array<String>]
    def initialize(board, cell_name, current_player, should_beat: nil)
      @board          = board
      @cell_name      = cell_name
      @current_player = current_player
      @should_beat = should_beat
    end

    # @return [Array<String>]
    def possible_moves
      valid_move_steps.map { |step| step.to_cell.name }
    end

    def possible_move_chains
      valid_move_steps.flat_map { |step| possible_next_steps(step) }
    end

    def possible_move_chains_cell_names
      possible_move_chains.map { |chain| chain.map { |m| m.to_cell.name } }
    end

    memoize def beat_move_steps
      possible_move_steps.select(&:beat?)
    end

    memoize def possible_move_steps
      board.playable_cells.map do |cell|
        MoveStep.build(board, [cell_name, cell.name], current_player)
      end.select(&:valid?)
    end

    memoize def valid_move_steps
      possible_move_steps.select(&method(:valid_move?))
    end

    def possible_next_steps(move_step)
      next_steps_groups =
        if should_beat?
          possible_next_moves_obj = self.class.new(
            move_step.perform,
            move_step.to_cell.name,
            current_player,
            should_beat: true
          )
          possible_next_moves_obj.valid_move_steps.flat_map do |next_step|
            possible_next_moves_obj.possible_next_steps(next_step)
          end
        else
          []
        end
      if next_steps_groups.present?
        next_steps_groups.map { |next_steps_group| [move_step, *next_steps_group] }
      else
        [[move_step]]
      end
    end

    memoize def should_beat?
      @should_beat || self.class.should_beat?(board, current_player)
    end

    class << self
      def all_beat_move_steps(board, player)
        all_possible_move_steps(board, player).select(&:beat?)
      end

      def should_beat?(board, player)
        all_possible_move_steps(board, player).any?(&:beat?)
      end

      def all_possible_move_steps(board, player)
        from_cells = board.occupied_cells.select { |c| c.draught.color == player }
        from_cells.flat_map do |cell|
          new(board, cell.name, player).possible_move_steps
        end
      end

      def all_possible_move_chains(board, player)
        from_cells = board.occupied_cells.select { |c| c.draught.color == player }
        from_cells.flat_map do |cell|
          new(board, cell.name, player).possible_move_chains
        end
      end
    end

    private

      def valid_move?(move_step)
        move_step.valid? && (!should_beat? || move_step.beat?)
      end
  end
end
