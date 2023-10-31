# frozen_string_literal: true

module Game
  class MatchSerializer < ActiveModel::Serializer
    attributes :id, :current_player_color, :current_player_id, :ruleset, :state, :started_at, :finished_at

    has_one :white_player
    has_one :black_player

    def started_at
      object.started_at&.strftime('%d.%m.%Y %H:%M')
    end

    def finished_at
      object.finished_at&.strftime('%d.%m.%Y %H:%M')
    end
  end
end
