# frozen_string_literal: true

module Game
  module Matches
    class MakeMove < ApplicationInteractor
      option :current_player
      option :match
      option :moves

      def call
        match.with_lock do
          yield check_current_player
          measure
          move
          win_condition_check
          MatchChannel.broadcast_with(match)
        end

        Success()
      rescue Gameplay::InvalidMove => e
        Failure([:invalid_move, e.message])
      end

      def check_current_player
        return Failure(:out_of_turn) unless current_player == match.current_player

        Success()
      end

      def measure
        Gameplay::CellBelongingCheck.new(match.board_instances, starting_cell_name, match.current_player_color).check!
        boards = Gameplay::CellMeasure.new(match.board_instances, starting_cell_name).perform
        match.current_turn.update boards: Gameplay::Serialization::JsonExport.new(boards).as_json
      end

      def move
        return unless Gameplay::CellBelongingCheck.new(
          match.board_instances, starting_cell_name, match.current_player_color
        ).check

        prev_turn = match.current_turn
        result = Gameplay.move prev_turn, moves, match.ruleset_object
        prev_turn.update move: result[:move]
        match.match_turns.create! result[:next_turn]
        match.touch # rubocop:disable Rails/SkipsModelValidations:
      end

      def win_condition_check
        result = Gameplay::WinCondition.new(
          match.board_instances,
          match.current_player_color,
          ruleset: match.ruleset_object
        ).perform

        return unless result[:finished]

        match.finish
        match.update winner: match.player_by_color(result[:winner])
      end

      private

      def starting_cell_name
        moves.first.first
      end
    end
  end
end
