# frozen_string_literal: true

module Gameplay
  class Draught
    include Dry::Equalizer(:id, :color, :king)

    attr_reader :id, :color, :king

    def initialize(id:, color:, king: false)
      @id    = id
      @color = expand_color(color)
      @king  = king
    end

    def as_json(*_args)
      {
        id: id,
        c:  short_color,
        k:  king,
      }
    end

    def black?
      color == :black
    end

    def white?
      color == :white
    end

    alias king? king

    def short_color
      color.to_s.first
    end

    def becomes_king
      self.class.new(id: id, color: color, king: true)
    end

    private

      def expand_color(color)
        case color
        when 'b'
          :black
        when 'w'
          :white
        else
          color.to_sym
        end
      end
  end
end
