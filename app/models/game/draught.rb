# frozen_string_literal: true

class Game::Draught
  include Dry::Equalizer(:id, :color)

  attr_accessor :id, :color

  def initialize(id:, color:)
    self.id = id
    self.color = expand_color(color)
  end

  def as_json(*args)
    {
        id: id,
        c: short_color
    }
  end

  def black?
    color == :black
  end

  def white?
    color == :white
  end

  def short_color
    color.to_s.first
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
