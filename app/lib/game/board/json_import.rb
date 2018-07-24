# frozen_string_literal: true

module Game
  class Board
    class JsonImport
      attr_reader :boards_json

      def initialize(boards_json)
        @boards_json = boards_json
      end

      def boards

      end

      private

        def boards_count
          boards_json['weights'].length
        end

        def boards_attributes
          initial_attributes = [{}] * boards_count

          boards_json.draughts.each do |draught_data|
            draught = Draught.new(
              id: draught_data['id'],
              color: draught_color(draught_data['id']),
              king: draught_data['king']),

            cell = Cell.new(draught_data['cell'])
          end
        end

        def draught_color(id)
          id < 12 ? :white : :black
        end

    end
  end
end
