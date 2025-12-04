# frozen_string_literal: true

## Клас, що представляє шаховий хід
##
## @attr from [String] початкова клітинка
## @attr to [String] кінцева клітинка
## @attr board [Board] дошка з позицією до виконання ходу
class Move
  attr_accessor :from, :to, :from_piece, :notation, :board, :fen_string

  def initialize(from, to, board)
    @from = from
    @to = to
    @board = board
    @from_piece = @board.get_piece_at(@from)
    @to_piece = @board.get_piece_at(@to)
    @fen_string = @board.to_fen
    @notation = nil
  end
end
