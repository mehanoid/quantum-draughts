# frozen_string_literal: true

module Game
  class Match < ApplicationRecord
    has_many :match_turns, dependent: :destroy

    enum ruleset: {
      english: 0,
      russian: 1,
    }

    def self.create_initial_match(params = {})
      match = create! params
      match.match_turns.build.init_boards
      match
    end

    def current_turn
      match_turns.last
    end

    def current_player
      current_turn.player
    end

    def board_instances
      current_turn.board_instances
    end

    def to_s
      current_turn.to_s
    end

    def ruleset_object
      Gameplay.const_get "#{ruleset.to_s.capitalize}Ruleset".to_sym
    end

    def rollback_turn!
      raise 'No turns available' if match_turns.count <= 1
      current_turn.destroy
      current_turn.update move: nil
    end
  end
end
