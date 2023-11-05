# frozen_string_literal: true

module Game
  class MatchTurnSerializer < ActiveModel::Serializer
    attributes :id, :turn_number, :player_color, :move
  end
end
