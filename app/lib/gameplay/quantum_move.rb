# frozen_string_literal: true

module Gameplay
  # Квантовый ход выполняет одни и те же указанные передвижения шашки на наборе досок
  class QuantumMove
    attr_reader :boards, :moves_params, :current_player, :ruleset

    # @param boards [Array<Gameplay::Types::Board>]
    def initialize(boards, moves_params, current_player, ruleset: RussianRuleset)
      @boards         = boards
      @moves_params   = moves_params
      @current_player = current_player
      @ruleset        = ruleset
    end

    def perform
      validate_moves_params!
      build_moves(moves_params)
        .then { perform_moves(_1) }
        .then { collapse_boards(_1) }
        .then { compact_boards(_1) }
    end

    # была ли на этом ходу побита хоть одна шашка
    def beat?
      build_moves(moves_params).any? { |m| m.valid? && m.beat? }
    end

    private

    def validate_moves_params!
      raise InvalidMove, 'moves should start with one cell' if moves_params.map(&:first).uniq.many?
    end

    def build_moves(moves_params)
      # TODO: add settings for this (or remove)
      move_groups = build_symmetric_move_groups(moves_params)
      # move_groups = build_assymetric_move_groups(moves_params)

      validate_move_groups!(move_groups)
      move_groups.flatten
    end

    def build_symmetric_move_groups(moves_params)
      moves_params.map do |move_params|
        boards.map do |board|
          Move.new(board, move_params, current_player, ruleset:)
        end
      end
    end

    def build_assymetric_move_groups(moves_params)
      [
        build_assymetric_group(moves_params.first, 2),
        build_assymetric_group(moves_params.last),
      ]
    end

    def build_assymetric_group(move_params, weight = 1)
      boards.map do |board|
        board = board.update weight: board.weight * weight if weight > 1 # rubocop:disable Style/RedundantSelfAssignment
        # TODO: подумать, как переименовать метод
        Move.new(board, move_params, current_player, ruleset:)
      end
    end

    def validate_move_groups!(move_groups)
      unless move_groups.any?
        # TODO: check for minimum two moves if they are available
        raise InvalidMove, 'too few moves'
      end

      # each move group should contain at least one valid move
      unless move_groups.all? { |moves_group| moves_group.any?(&:valid?) }
        raise InvalidMove, 'one of the moves is invalid'
      end

      raise InvalidMove, 'can not stop if can beat' unless move_groups.flatten.all?(&:can_partial_perform?)
    end

    def perform_moves(moves)
      moves.map do |move|
        if move.valid?
          move.perform
        else
          move.perform_while_valid
        end
      end
    end

    def collapse_boards(boards)
      BoardsCollapse.new(boards).perform
    end

    def compact_boards(boards)
      BoardsCompact.new(boards).perform
    end
  end
end
