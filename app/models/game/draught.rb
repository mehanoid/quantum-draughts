# frozen_string_literal: true

class Game::Draught
  attr_accessor :id, :color

  def initialize(id:, color:)
    self.id = id
    self.color = expand_color(color)
  end

  def as_json(*args)
    {
        id: id,
        c: color.to_s.first
    }
  end

  private

  def expand_color(color)
    case color
      when 'b'
        :black
      when 'w'
        :white
      else
        color
    end
  end
end
