# frozen_string_literal: true

module Game
  module Gameplay
    class Board
      # converts multiboard to json
      class JsonExport
        attr_reader :boards

        def initialize(boards)
          @boards = boards
        end

        def as_json
          {
            weights:  boards_json,
            draughts: cells_json,
          }
        end

        private

          def boards_json
            boards.map(&:weight)
          end

          def cells_json
            cell_names = boards.first.cells.map(&:name)
            cell_names.map do |cell_name|
              draughts_data = draughts_with_boards_indexes(boards, cell_name).map(&method(:draught_json))
              next if draughts_data.empty?
              {
                cell: cell_name,
              }.merge(draughts_data[0])
            end.compact
          end

          # @return [Hash<Game::Draught, Array<Integer>>]
          def draughts_with_boards_indexes(boards, cell_name)
            draughts_with_indexes = boards.map.with_index do |board, board_index|
              draught = board.cell_at(cell_name).draught
              [draught, board_index] if draught
            end.compact

            draughts_with_indexes
              .group_by { |draught, _i| draught }
              .transform_values { |draughts| draughts.map { |_d, i| i } }
          end

          def draught_json(draught, indexes)
            {
              id:     draught.id,
              king:   draught.king,
              boards: indexes,
            }
          end
      end
    end
  end
end
