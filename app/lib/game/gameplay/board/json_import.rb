# frozen_string_literal: true

module Game
  module Gameplay
    class Board
      class JsonImport
        attr_reader :boards_json

        def initialize(boards_json)
          @boards_json = boards_json
        end

        def boards
          initial_board = Board.new
          boards_attributes.map.with_index do |board_attributes, index|
            board        = initial_board.update(board_attributes)
            board.weight = boards_json['weights'][index]
            board
          end
        end

        private

          def boards_count
            boards_json['weights'].length
          end

          def boards_attributes
            attributes = Array.new(boards_count) { {} }

            boards_json['draughts'].each do |draught_data|
              draught = build_draught(draught_data)
              draught_data['boards'].each do |board_index|
                attributes[board_index][draught_data['cell']] = draught
              end
            end
            attributes
          end

          def build_draught(data)
            Draught.new(
              id:    data['id'],
              color: draught_color(data['id']),
              king:  data['king'],
            )
          end

          def draught_color(id)
            id <= 12 ? :white : :black
          end
      end
    end
  end
end
