# frozen_string_literal: true

require 'deep_clone'
require 'yaml'

require_relative './pieces/knight'
require_relative './pieces/king'
require_relative './pieces/queen'
require_relative './pieces/pawn'
require_relative './pieces/rook'
require_relative './board/board'
require_relative './player'
require_relative './computer_player'
require_relative './moves/move_creator'
require_relative './errors/illegal_move'
require_relative './moves/normal_move'
require_relative './moves/castle_move'
require_relative './moves/capture_move'
require_relative './moves/promotion_move'
require_relative './moves/first_pawn_move'
require_relative './moves/pawn_capture_move'
require_relative './moves/en_passant_move'

## Головний клас для шахової гри
##
## @attr board [Board] дошка з поточною позицією гри
## @attr white_player [Player] гравець, пов'язаний з білими
## @attr black_player [Player] гравець, пов'язаний з чорними
class Chess
  include MoveCreator

  attr_reader :moves_list, :turn, :board, :white_player, :black_player
  attr_accessor :result

  def initialize(board, white_player, black_player)
    @board = board
    @moves_list = []
    @white_player = white_player
    @black_player = black_player
    @turn = @white_player
    @result = nil
  end

  # Додає дійсний хід до поточної гри та оновлює статус гри
  # @attr move [Move] хід, який ми хочемо додати до поточної гри
  def add_move(move)
    move.validate
    validate_move_turn(move)
    validate_not_results_in_check_for_own_king(move)
    piece_to_move = @board.get_piece_at(move.from)
    piece_to_move.moved = true if piece_to_move.is_a?(King) || piece_to_move.is_a?(Rook)

    move.execute
    generate_notation(move)

    @moves_list << move
    switch_turn
    @board.last_move = move
    @board.to_move = @turn.color
  end

  # Перевіряє, чи належить переданий +move+ фігурі поточного гравця
  # @param move [Move] хід, який ми хочемо виконати на дошці
  def validate_move_turn(move)
    raise IllegalMoveError, 'Неприпустима фігура' if move.from_piece.nil? || move.from_piece.color != @turn.color
  end

  # Перевіряє, що переданий +move+ не ставить у шах власного короля
  # @param move [Move] хід, який ми перевіряємо
  def validate_not_results_in_check_for_own_king(move)
    raise IllegalMoveError, 'Не можна поставити короля під шах' if will_put_my_king_in_check(move)
  end

  # Перемикає чергу гравців (поточний гравець)
  def switch_turn
    @turn = @turn.color == 'white' ? @black_player : @white_player
  end

  # Зберігає поточну гру серіалізацією об'єкта у YAML рядок
  # @return [String] YAML-представлення поточної гри
  def serialize
    YAML.dump(self)
  end

  # Перевіряє чи сторона +army+ на дошці +board+ знаходиться під матом
  # (у шаху та без легальних ходів)
  # @return [Boolean]
  def checkmate?(board, army)
    return false unless board.in_check?(army)

    checkmate = false
    coordinates = []
    8.times do |number|
      coordinates << ('a'..'h').to_a.map! { |rank| rank + (number + 1).to_s }
    end

    board.pieces(army).each do |piece|
      from = board.get_coordinate(piece)

      coordinates.flatten.each do |to|
        move = create_move(from, to, board)
        begin
          validate_move_turn(move)
          validate_not_results_in_check_for_own_king(move)
          move.validate
          return false
        rescue IllegalMoveError, InvalidCoordinateError
          checkmate = true
        end
      end
    end

    checkmate
  end

  # Перевіряє чи сторона +army+ на дошці +board+ у патовій ситуації (немає лег. ходів)
  # @return [Boolean]
  def stealmate?(board, army)
    return false if board.in_check?(army)

    stealmate = true
    coordinates = []
    8.times do |number|
      coordinates << ('a'..'h').to_a.map! { |rank| rank + (number + 1).to_s }
    end

    board.pieces(army).each do |piece|
      from = board.get_coordinate(piece)

      coordinates.flatten.each do |to|
        move = create_move(from, to, board)
        begin
          validate_move_turn(move)
          validate_not_results_in_check_for_own_king(move)
          move.validate
          return false
        rescue IllegalMoveError, InvalidCoordinateError
          stealmate = true
        end
      end
    end

    stealmate
  end

  # Перевіряє, чи остання позиція повторюється тричі (правило трикратного повторення)
  def threefold_repetition?
    # Check if last position has been repeated for at least 3 times
    last_postion = @moves_list.last.fen_string

    @moves_list.select { |move| move.fen_string == last_postion }.length >= 2
  end

  # Визначає, чи позиція на +board+ є нічиєю через недостатність матеріалу
  # для матування суперника обох сторін
  def insuficient_material?(board)
    # Checks any of these for both sides
    # - A lone king
    # - A king and a bishop
    # - A king and a knight
    white_pieces = board.pieces('white')
    black_pieces = board.pieces('black')

    return true if white_pieces.length == 1 && black_pieces.length == 1
    return false if white_pieces.length > 2 || black_pieces.length > 2

    # One piece must be the king, so the other must be either a bishop or a knight
    black_insuficient_material = !black_pieces.select { |piece| piece.is_a?(Knight) || piece.is_a?(Bishop) }.empty?
    white_insuficient_material = !white_pieces.select { |piece| piece.is_a?(Knight) || piece.is_a?(Bishop) }.empty?

    black_insuficient_material && white_insuficient_material
  end

  # Завантажує раніше збережену гру шахів
  # @param yaml_string [String] рядок, збережений за допомогою YAML.dump()
  def self.unserialize(yaml_string)
    YAML.safe_load(yaml_string,
                   permitted_classes: [Chess, Board, Move, Player, ComputerPlayer, Pawn, Knight, Rook, Bishop, King, Queen, NormalMove, PromotionMove, CaptureMove, CastleMove, PawnCaptureMove, FirstPawnMove, EnPassantMove], aliases: true)
  end

  private

  # Перевіряє, що переданий хід не призведе до шаху власного короля
  # @param from [String] початкова клітинка
  # @param to [String] кінцева клітинка
  # @return [Boolean] true якщо хід ставить власного короля під шах
  def will_put_my_king_in_check(move)
    board_clone = DeepClone.clone(@board)
    move.board = board_clone # We need to perform the move in the board clone

    begin
      move.validate
      move.execute
      move.board = @board # Set the original board
      board_clone.in_check?(@turn.color)
    rescue IllegalMoveError, InvalidCoordinateError
      # It's an Illegal move -> cannot be added
      true
    end
  end

  # Визначає, чи хід призводить до шаху або шах-мату супротивника
  # і додає відповідний символ до нотації ходу
  # @param move [Move] хід, для якого формуємо нотацію
  def generate_notation(move)
    switch_turn
    @board.to_move = @turn.color
    check = @board.in_check?(@turn.color) ? '+' : ''
    checkmate = checkmate?(@board, @turn.color) ? '#' : ''

    move.notation = "#{move.long_algebraic_notation}#{checkmate.empty? ? check : checkmate}"
    switch_turn
    @board.to_move = @turn.color
  end
end
