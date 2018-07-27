# frozen_string_literal: true

module Game
  class MatchTurnDetailsSerializer < MatchTurnSerializer
    attributes :boards

    def boards
      object.board_instances.map(&:as_json)
    end
  end
end
