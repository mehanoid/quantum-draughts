# frozen_string_literal: true

module Game
  module Gameplay
    class MoveStep
      include Memery
      attr_reader :from_cell, :to_cell, :prev_beaten_cells, :current_player, :board

      class << self
        def build(board, move_cells, current_player = nil, prev_beaten_cells: [])
          from_cell = board.cell_at(move_cells.first)
          klass     =
            if from_cell.draught&.king?
              Game::Gameplay::KingMoveStep
            else
              Game::Gameplay::ManMoveStep
            end
          klass.new(board, move_cells, current_player, prev_beaten_cells: prev_beaten_cells)
        end
      end

      # @param board [Game::Gameplay::Board]
      # @param move_cells [Array<String>]
      def initialize(board, move_cells, current_player = nil, prev_beaten_cells: [])
        @board             = board
        @params            = move_cells
        from, to           = @params
        @from_cell         = @board.cell_at(from)
        @to_cell           = @board.cell_at(to)
        @prev_beaten_cells = prev_beaten_cells
        @current_player    = current_player
      end

      def perform
        validate!
        result
      end

      def valid?
        error.blank?
      end

      def beat?
        current_beaten_cells.present?
      end

      def beaten_cells
        prev_beaten_cells | current_beaten_cells
      end

      def validate!
        raise InvalidMove, error unless valid?
      end

      def error
        return 'source is empty' unless from_cell.occupied?
        return "other player's turn" unless current_player == draught.color
        return 'destination is not playable' unless to_cell.playable
        return 'destination is occupied' unless to_cell.empty?
        return 'cells are not on the same diagonal' unless from_cell.same_diagonal?(to_cell)
        return 'can not move back' unless valid_direction?
        if current_beaten_cells.present?
          return 'can not beat same draught multiple times' unless valid_unique_beaten_cells?
          return 'invalid beating' unless valid_beaten_cells_order?
          return 'can not beat draught of the same color' unless valid_beaten_draughts_color?
        else
          return 'invalid move distance' unless valid_move_distance?
        end
      end

      def draught
        from_cell.draught
      end

      private

        memoize def result
          board.update attributes_for_update
        end

        def attributes_for_update
          {
            from_cell.name => nil,
            to_cell.name   => draught,
          }.merge(current_beaten_cells.map do |c|
            [c.name, nil]
          end.to_h)
        end

        def current_beaten_cells
          @board.cells_between(from_cell, to_cell).select(&:occupied?)
        end

        def valid_beaten_draughts_color?
          current_beaten_cells.none? { |c| c.draught.color == draught.color }
        end

        def valid_unique_beaten_cells?
          prev_beaten_cells.none? { |beaten_cell| beaten_cell.between?(from_cell, to_cell) }
        end

        def valid_direction?
          raise 'abstract method'
        end

        def valid_beaten_cells_order?
          raise 'abstract method'
        end

        def valid_move_distance?
          raise 'abstract method'
        end
    end
  end
end
