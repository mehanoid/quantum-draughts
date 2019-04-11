# frozen_string_literal: true

module Game
  class MatchSerializer < ActiveModel::Serializer
    attributes :id, :current_player_color, :ruleset, :state

    has_one :white_player, serializer: UserSerializer
    has_one :black_player, serializer: UserSerializer

  end
end
