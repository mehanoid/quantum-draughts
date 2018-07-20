# frozen_string_literal: true

class MatchSerializer < ActiveModel::Serializer
  attributes :id, :boards, :current_player, :possible_moves

  def possible_moves
    Game::PossibleQuantumMoves.valid_possible_move_chains(object.board_instances, object.current_player.to_sym)
  end
end
