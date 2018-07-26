module Game
  class MatchTurn < ApplicationRecord
    enum player: { white: 0, black: 1 }

    belongs_to :match

    def init_boards
      board       = Game::Gameplay::Board.populated
      self.boards = Game::Gameplay::Board::JsonExport.new([board]).as_json
      save
      self
    end

    def board_instances
      Game::Gameplay::Board::JsonImport.new(boards).boards
    end

    def to_s
      board_instances.map do |b|
        "#{b.weight}\n#{b}\n"
      end
    end
  end
end
