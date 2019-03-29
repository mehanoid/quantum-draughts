# frozen_string_literal: true

module Game
  module Gameplay
    class QuantumMovesCalculator
      attr_reader :boards, :cell_name, :current_player, :ruleset

      def initialize(boards, cell_name, current_player, ruleset: RussianRuleset)
        @boards         = boards
        @cell_name      = cell_name
        @current_player = current_player
        @ruleset = ruleset
      end

      # @return [Array<String>]
      def possible_moves
        possible_move_steps.select(&method(:valid_move?)).map { |step| step.to_cell.name }.uniq
      end

      def possible_move_chains
        boards.flat_map do |board|
          MovesCalculator.new(board, cell_name, current_player, ruleset: ruleset).possible_move_chains
        end.select { |chain| valid_move?(chain.first) }
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

      class << self
        def all_beat_move_steps(boards, player, ruleset: Game::Gameplay::RussianRuleset)
          all_possible_move_steps(boards, player, ruleset: ruleset).select(&:beat?)
        end

        def any_can_beat?(boards, player, ruleset: Game::Gameplay::RussianRuleset)
          boards.any? do |board|
            Game::Gameplay::MovesCalculator.any_can_beat?(board, player, ruleset: ruleset)
          end
        end

        def all_possible_move_steps(boards, player, ruleset: Game::Gameplay::RussianRuleset)
          boards.flat_map do |board|
            Game::Gameplay::MovesCalculator.all_possible_move_steps(board, player, ruleset: ruleset)
          end
        end

        def all_possible_move_chains(boards, player, ruleset: Game::Gameplay::RussianRuleset)
          boards.flat_map do |board|
            Game::Gameplay::MovesCalculator.all_possible_move_chains(board, player, ruleset: ruleset)
          end
        end

        def valid_possible_move_chains(boards, player, ruleset: Game::Gameplay::RussianRuleset)
          if any_can_beat?(boards, player, ruleset: ruleset)
            all_possible_move_chains(boards, player, ruleset: ruleset).select { |chain| chain.first.beat? }
          else
            all_possible_move_chains(boards, player, ruleset: ruleset)
          end.then(&method(:reject_included_in_other_moves))
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
            chains.reduce(chains, &method(:reject_moves_included_in))
          end

          def reject_moves_included_in(chains, chain)
            cells = chain_cells(chain)
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

      private

        def valid_move?(move_step)
          move_step.valid? && (any_can_beat?.blank? || move_step.beat?)
        end
    end
  end
end
