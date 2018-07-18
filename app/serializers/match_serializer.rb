# frozen_string_literal: true

class MatchSerializer < ActiveModel::Serializer
  attributes :id, :boards, :current_player, :possible_moves

  def possible_moves
    Game::PossibleQuantumMoves.new(object.board_instances, 'A1', object.current_player.to_sym).all_possible_moves
  end
end
