# frozen_string_literal: true

require_relative './player'
require_relative './moves/move_creator'

## Клас, що представляє комп'ютерного гравця в шахах
##
## @attr colour [String] колір фігур гравця
class ComputerPlayer < Player
  include MoveCreator

  def initialize(color, board)
    super(color)
    @board = board
  end

  # Повертає випадковий хід
  def play_move
    loop do
      from = random_rank + random_file
      to = random_rank + random_file
      begin
        move = create_move(from, to, @board)
        move.validate
        return move
      rescue IllegalMoveError, InvalidCoordinateError
        # Хід недійсний
        next
      end
      break
    end
  end

  private

  def random_rank
    ('a'..'h').to_a.sample
  end

  def random_file
    ('1'..'8').to_a.sample
  end
end
