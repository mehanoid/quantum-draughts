# frozen_string_literal: true

module Game
  module Gameplay
    class BoardsCompact
      def initialize(boards)
        @boards = boards
      end

      def perform
        calc_boards_weights(@boards)
          .yield_self(&method(:reduce_boards_weights))
          .yield_self(&method(:make_board_list))
      end

      private

        def calc_boards_weights(boards)
          boards.group_by(&:itself).transform_values { |boards_group| boards_group.sum(&:weight) }
        end

        def reduce_boards_weights(boards_weights)
          boards_weights.transform_values { |weight| weight / greatest_common_divisor(boards_weights) }
        end

        def make_board_list(boards_weights)
          boards_weights.each do |board, weight|
            board.weight = weight
          end
          boards_weights.keys
        end

        def greatest_common_divisor(boards_weights)
          boards_weights.values.reduce(&:gcd)
        end
    end
  end
end
