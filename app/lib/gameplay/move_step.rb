# frozen_string_literal: true

module Gameplay
  class MoveStep
    attr_reader :from_cell, :to_cell, :prev_beaten_cells, :current_player, :board

    class << self
      def build(*args)
        from_cell = board.cell_at(move_cells.first)
        klass     =
          if from_cell.draught&.king?
            Gameplay::KingMoveStep
          else
            Gameplay::ManMoveStep
          end
        klass.new(*args)
      end
    end

    # @param board [Types::Board]
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

    # @return [Types::Board]
    def perform
      validate!
      result
    end

    def valid?
      error.blank?
    end

    # была на этом шаге побита какая-либо шашка
    def beat?
      current_beaten_cells.present?
    end

    def beaten_cells
      prev_beaten_cells | current_beaten_cells
    end

    def validate!
      raise InvalidMove, error unless valid?
    end

    def error # rubocop:disable Metrics/PerceivedComplexity
      return 'source is empty' unless from_cell.occupied?
      return "other player's turn" unless current_player == draught.color
      return 'destination is not playable' unless to_cell.playable
      return 'destination is occupied' unless to_cell.empty?
      return 'cells are not on the same diagonal' unless from_cell.same_diagonal?(to_cell)
      return 'can not move back' unless valid_direction?

      if current_beaten_cells.present?
        return 'can not beat same draught multiple times' unless valid_unique_beaten_cells?
        return 'invalid beating' unless valid_beaten_cells_order?

        'can not beat draught of the same color' unless valid_beaten_draughts_color?
      else
        'invalid move distance' unless valid_move_distance?
      end
    end

    delegate :draught, to: :from_cell

    private

    def result
      board.update attributes_for_update
    end

    def attributes_for_update
      {
        from_cell.coordinate => nil,
        to_cell.coordinate   => draught,
      }.merge(current_beaten_cells.to_h do |c|
        [c.coordinate, nil]
      end)
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
