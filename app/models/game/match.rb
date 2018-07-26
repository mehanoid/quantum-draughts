# frozen_string_literal: true

module Game
  class Match < ApplicationRecord

    has_many :match_turns, dependent: :destroy

    def current_turn
      match_turns.last
    end

    def current_player
      current_turn.player
    end

    def board_instances
      current_turn.board_instances
    end

    def self.create_initial_match
      match = create!
      match.match_turns.build.init_boards
      match
    end

    def to_s
      current_turn.to_s
    end
  end
end
