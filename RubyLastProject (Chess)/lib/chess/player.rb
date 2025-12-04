# frozen_string_literal: true

## Клас, що представляє гравця в шахах
##
## @attr colour [String] колір фігур гравця
class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end
end
