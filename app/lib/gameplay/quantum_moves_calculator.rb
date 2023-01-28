# frozen_string_literal: true

module Gameplay
  class QuantumMovesCalculator
    attr_reader :boards, :cell_name, :current_player, :ruleset

    def initialize(boards, cell_name, current_player, ruleset: RussianRuleset)
      @boards         = boards
      @cell_name      = cell_name
      @current_player = current_player
      @ruleset        = ruleset
    end

    # @return [Array<String>]
    def possible_moves
      possible_move_steps.select(&method(:valid_move?)).map { |step| step.to_cell.name }.uniq
    end

    def possible_move_chains
      chains = boards.flat_map do |board|
        MovesCalculator.new(board, cell_name, current_player, ruleset: ruleset).possible_move_chains
      end
      chains.select { |chain| valid_move?(chain.first) }
    end

    def possible_move_chains_cell_names
      possible_move_chains.map { |chain| chain.map { |m| m.to_cell.name } }
    end

    def all_possible_moves
      if any_can_beat?
        all_beat_move_steps
      else
        all_possible_move_steps
      end.map do |step|
        {
          beat:  step.beat?,
          cells: [step.from_cell.name, step.to_cell.name],
        }
      end.uniq
    end

    def possible_move_steps
      boards.flat_map do |board|
        MovesCalculator.new(board, cell_name, current_player, ruleset: ruleset).possible_move_steps
      end
    end

    def all_possible_move_steps
      self.class.all_possible_move_steps(boards, current_player)
    end

    def all_beat_move_steps
      self.class.all_beat_move_steps(boards, current_player)
    end

    def any_can_beat?
      self.class.any_can_beat?(boards, current_player)
    end

    private

    def valid_move?(move_step)
      move_step.valid? && (any_can_beat?.blank? || move_step.beat?)
    end
  end
end
