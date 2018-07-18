# frozen_string_literal: true

module Game
  class PossibleQuantumMoves
    include Memery

    attr_reader :boards, :cell_name, :current_player

    # @param [Game::Board] board
    # @param [Array<String>] move_cells
    def initialize(boards, cell_name, current_player)
      @boards         = boards
      @cell_name      = cell_name
      @current_player = current_player
    end

    # @return [Array<String>]
    def possible_moves
      possible_move_steps.select(&method(:valid_move?)).map { |step| step.to_cell.name }.uniq
    end

    def all_possible_moves
      if all_beat_move_steps.present?
        all_beat_move_steps
      else
        all_possible_move_steps
      end.map do |step|
        {
          beat: step.beat?,
          cells: [step.from_cell.name, step.to_cell.name]
        }
      end.uniq
    end

    memoize def possible_move_steps
      boards.flat_map do |board|
        PossibleMoves.new(board, cell_name, current_player).possible_move_steps
      end
    end

    memoize def all_possible_move_steps
      self.class.all_possible_move_steps(boards, current_player)
    end

    memoize def all_beat_move_steps
      self.class.all_beat_move_steps(boards, current_player)
    end

    class << self
      def all_beat_move_steps(boards, player)
        all_possible_move_steps(boards, player).select(&:beat?)
      end

      def all_possible_move_steps(boards, player)
        boards.flat_map do |board|
          Game::PossibleMoves.all_possible_move_steps(board, player)
        end
      end
    end

    private

      def valid_move?(move_step)
        move_step.valid? && (all_beat_move_steps.blank? || move_step.beat?)
      end
  end
end
