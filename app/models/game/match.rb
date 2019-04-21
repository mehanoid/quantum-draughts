# frozen_string_literal: true

module Game
  class Match < ApplicationRecord
    include AASM

    has_many :match_turns, dependent: :destroy

    belongs_to :white_player, class_name: 'User', optional: true
    belongs_to :black_player, class_name: 'User', optional: true
    belongs_to :winner, class_name: 'User', optional: true

    enum ruleset: {
      english: 0,
      russian: 1,
    }

    enum state: {
      new_match: 0,
      ready: 1,
      started: 2,
      finished: 3,
      interrupted: 4,
    }

    aasm column: :state do
      state :new_match, initial: true
      state :ready
      state :started, before_enter: -> { self.started_at = Time.current }
      state :finished, before_enter: -> { self.finished_at = Time.current }
      state :interrupted

      event :start do
        transitions from: %i[new_match ready], to: :started
      end

      event :finish do
        transitions from: %i[started], to: :finished
      end
    end

    scope :active, -> { where(state: %i[new_match ready started]) }

    def self.create_initial_match(params = {})
      match = create! params
      match.match_turns.build.init_boards
      match
    end

    def current_turn
      match_turns.last
    end

    def current_player_color
      current_turn.player.to_sym
    end

    def current_player
      current_turn.white? ? white_player : black_player
    end

    def players
      [white_player, black_player].compact
    end

    def player_by_color(color)
      color.to_sym == :white ? white_player : black_player
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
      update state: :started, winner_id: nil
    end
  end
end
