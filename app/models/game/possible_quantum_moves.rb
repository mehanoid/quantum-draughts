# frozen_string_literal: true

module Game
  class PossibleQuantumMoves
    include Memery

    attr_reader :boards, :cell_name, :current_player

    def initialize(boards, cell_name, current_player)
      @boards         = boards
      @cell_name      = cell_name
      @current_player = current_player
    end

    # @return [Array<String>]
    def possible_moves
      possible_move_steps.select(&method(:valid_move?)).map { |step| step.to_cell.name }.uniq
    end

    def possible_move_chains
      boards.flat_map do |board|
        PossibleMoves.new(board, cell_name, current_player).possible_move_chains
      end.select { |chain| valid_move?(chain.first) }
    end

    def possible_move_chains_cell_names
      possible_move_chains.map { |chain| chain.map { |m| m.to_cell.name } }
    end

    def all_possible_moves
      if should_beat?
        all_beat_move_steps
      else
        all_possible_move_steps
      end.map do |step|
        {
          beat: step.beat?,
          cells: [step.from_cell.name, step.to_cell.name],
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

    memoize def should_beat?
      self.class.should_beat?(boards, current_player)
    end

    class << self
      def all_beat_move_steps(boards, player)
        all_possible_move_steps(boards, player).select(&:beat?)
      end

      def should_beat?(boards, player)
        boards.any? do |board|
          Game::PossibleMoves.should_beat?(board, player)
        end
      end

      def all_possible_move_steps(boards, player)
        boards.flat_map do |board|
          Game::PossibleMoves.all_possible_move_steps(board, player)
        end
      end

      def all_possible_move_chains(boards, player)
        boards.flat_map do |board|
          Game::PossibleMoves.all_possible_move_chains(board, player)
        end
      end

      def valid_possible_move_chains(boards, player)
        if should_beat?(boards, player)
          all_possible_move_chains(boards, player).select { |chain| chain.first.beat? }
        else
          all_possible_move_chains(boards, player)
        end.map do |chain|
          {
            beat:  chain.first.beat?,
            cells: [chain.first.from_cell.name, *chain.map { |step| step.to_cell.name }],
          }
        end.uniq
      end
    end

    private

      def valid_move?(move_step)
        move_step.valid? && (should_beat?.blank? || move_step.beat?)
      end
  end
end
