# frozen_string_literal: true

module Gameplay
  # Устраняет дублирование досок путём объединения одинаковых досок в одну с указанием веса
  # Кроме того, если веса содержат общий делитель, то выполняет сокращение на этот делитель
  class BoardsCompact
    def initialize(boards)
      @boards = boards
    end

    def perform
      calc_boards_weights(@boards)
        .then { reduce_boards_weights _1 }
        .then { make_board_list _1 }
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
        board.update weight:
      end
    end

    def greatest_common_divisor(boards_weights)
      boards_weights.values.reduce(&:gcd)
    end
  end
end
