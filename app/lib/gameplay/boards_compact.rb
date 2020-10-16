# frozen_string_literal: true

module Gameplay
  class BoardsCompact
    def initialize(boards)
      @boards = boards
    end

    def perform
      calc_boards_weights(@boards)
        .then(&method(:reduce_boards_weights))
        .then(&method(:make_board_list))
    end

    private

      def calc_boards_weights(boards)
        boards.group_by(&:itself).transform_values { |boards_group| boards_group.sum(&:weight) }
      end

      def reduce_boards_weights(boards_weights)
        boards_weights.transform_values { |weight| weight / greatest_common_divisor(boards_weights) }
      end

      def make_board_list(boards_weights)
        boards_weights.map do |board, weight|
          board.update weight: weight
        end
      end

      def greatest_common_divisor(boards_weights)
        boards_weights.values.reduce(&:gcd)
      end
  end
end