# frozen_string_literal: true

module Game
  class MatchTurn < ApplicationRecord
    enum player: { white: 0, black: 1 }

    belongs_to :match

    def init_boards
      board       = Gameplay::Types::Board.populated
      self.boards = Gameplay::Serialization::JsonExport.new([board]).as_json
      save
      self
    end

    def board_instances
      Gameplay::Serialization::JsonImport.new(boards).boards
    end

    def player_user
      white? ? match.white_player : match.black_player
    end

    def to_s
      board_instances.map do |b|
        "#{b.weight}\n#{b}\n"
      end
    end
  end
end
