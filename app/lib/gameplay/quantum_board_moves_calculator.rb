# frozen_string_literal: true

module Gameplay
  class QuantumBoardMovesCalculator
    attr_reader :boards, :current_player, :ruleset

    def initialize(boards, current_player, ruleset: RussianRuleset)
      @boards         = boards
      @current_player = current_player
      @ruleset        = ruleset
    end

    def all_beat_move_steps
      all_possible_move_steps.select(&:beat?)
    end

    def any_can_beat?
      boards.any? do |board|
        Gameplay::BoardMovesCalculator.new(board, current_player, ruleset:).any_can_beat?
      end
    end

    def all_possible_move_steps
      boards.flat_map do |board|
        Gameplay::BoardMovesCalculator.new(board, current_player, ruleset:).all_possible_move_steps
      end
    end

    def all_possible_move_chains
      boards.flat_map do |board|
        Gameplay::BoardMovesCalculator.new(board, current_player, ruleset:).all_possible_move_chains
      end
    end

    def valid_possible_move_chains
      if any_can_beat?
        all_possible_move_chains.select { |chain| chain.first.beat? }
      else
        all_possible_move_chains
      end.then { reject_included_in_other_moves(_1) }
        .map do |chain|
        {
          beat:  chain.first.beat?,
          cells: chain_cells(chain),
        }
      end.uniq
    end

    private

    def chain_cells(chain)
      [chain.first.from_cell.name, *chain.map { |step| step.to_cell.name }]
    end

    def reject_included_in_other_moves(chains)
      chains.reduce(chains) { |*args| reject_moves_included_in(*args) }
    end

    def reject_moves_included_in(chains, chain)
      cells        = chain_cells(chain)
      beaten_cells = chain.last.beaten_cells
      chains.reject do |ch|
        !ch.equal?(chain) && ch.first.from_cell.coordinate == chain.first.from_cell.coordinate &&
          (cells_include_chain?(cells, ch) || beaten_cells_include_chain?(beaten_cells, ch))
      end
    end

    def cells_include_chain?(cells, chain)
      cells.first(chain.length) == chain_cells(chain)
    end

    def beaten_cells_include_chain?(beaten_cells, chain)
      chain_beaten_cells = chain.last.beaten_cells
      beaten_cells.length > chain_beaten_cells.length &&
        beaten_cells.first(chain_beaten_cells.length) == chain_beaten_cells
    end
  end
end
