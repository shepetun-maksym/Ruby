# frozen_string_literal: true

require 'deep_clone'

require_relative '../errors/invalid_coordinate'
require_relative '../errors/illegal_move'
require_relative '../moves/move_creator'

class Board
  include MoveCreator

  attr_reader :squares
  attr_accessor :last_move, :to_move

  def initialize
    @squares = Array.new(8) { Array.new(8, nil) }
    @to_move = 'white'
  end

  def add_piece(piece, coordinate)
    rank, file = parse_coordinate(coordinate)
    squares[rank][file] = piece
  end

  def blocked_path?(from, to)
    direction = calculate_direction_vector(from, to)
    current_square = next_square(from, direction)

    until current_square == to
      return true unless get_piece_at(current_square).nil?

      current_square = next_square(current_square, direction)
    end
    false
  end

  def calculate_distance_vector(from, to)
    from_rank, from_file = parse_coordinate(from)
    to_rank, to_file = parse_coordinate(to)

    [to_rank - from_rank, to_file - from_file]
  end

  # Повертає одиничний вектор напрямку для заданого шляху
  # @param from [String] початкова координата поля
  # @param to [String] кінцева координата поля
  # @raise [IllegalMoveError] піднімається, якщо шлях не є дійсним для шахової фігури
  def calculate_direction_vector(from, to)
    distance_vector = calculate_distance_vector(from, to)

    # Перевіряємо, чи не є рух недіагональним та не по прямій (наприклад a1 -> e2)
    if !distance_vector.include?(0) && distance_vector[0].abs != distance_vector[1].abs
      raise IllegalMoveError, 'Недійсний напрямок руху'
    end

    distance_vector.map { |item| item.zero? ? 0 : item / item.abs }
  end

  # Перевіряє, чи шлях від +from+ до +to+ атакує ворожа сторона
  # Використовується для валідації рокіровки
  # @param from [String] початкова координата поля
  # @param to [String] кінцева координата поля
  # @param army [String] колір сторони, для якої перевіряємо атаку
  def path_attacked?(from, to, army)
    direction = calculate_direction_vector(from, to)
    current_square = next_square(from, direction)

    until current_square == to
      @squares.flatten.each do |piece|
        next if piece.nil? || piece.color == army

        return true if piece.can_move_to?(self, get_coordinate(piece),
                                          current_square) && !blocked_path?(get_coordinate(piece), current_square)
      end
      current_square = next_square(current_square, direction)
    end
    false
  end

  # Перевіряє, чи знаходиться передана сторона у шаху у поточній позиції
  # @param army [String] колір сторони, яку перевіряємо
  # @return [Boolean] true якщо сторона у шаху, інакше false
  def in_check?(army)
    board_clone = DeepClone.clone(self)
    opponent_pieces = board_clone.pieces(army == 'white' ? 'black' : 'white')
    king = board_clone.pieces(army).select { |piece| piece.is_a?(King) }.first

    opponent_pieces.each do |piece|
      from = board_clone.get_coordinate(piece)

      move = create_move(from, board_clone.get_coordinate(king), board_clone)
      begin
        # Знайдено хід, що може захопити короля
        move.validate
        return true
      rescue IllegalMoveError, InvalidCoordinateError
        # Це недійсний хід, тому його не можна виконати — він не призводить до шаху
        # Продовжуємо пошук ходів, які бать могли захопити короля
        next
      end
    end
    false
  end

  # Повертає поточну дошку у форматі FEN (рядок)
  # Повертає лише першу частину FEN без лічильника півходів і номера ходу
  # Використовується для перевірки правила трикратного повторення позиції
  # @return [String] рядок, що описує позицію дошки
  def to_fen
    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR
    fen_string = ''

    # Pieces position
    @squares.reverse.each_with_index do |row, index|
      blank_squares = 0
      row.each do |piece|
        if piece.nil?
          blank_squares += 1
        else
          fen_string += blank_squares.to_s unless blank_squares.zero?
          fen_string += piece.fen_representation
          blank_squares = 0
        end
      end
      fen_string += blank_squares.to_s unless blank_squares.zero?
      fen_string += '/' unless index == 7
    end

    # Side to move
    fen_string += " #{@to_move[0]}"

    # Castling availability
    fen_string += " #{available_castles}"

    # En passant target square
    en_passant_target_square = @last_move.is_a?(FirstPawnMove) ? @last_move.en_passant_target_square : nil
    fen_string += " #{en_passant_target_square.nil? ? '-' : en_passant_target_square}"

    fen_string
  end

  # Returns the pieces of the passed +army+ on the board
  # @param army [String] the color of the army the pieces we want
  # @return [Array] an array of containing all pieces on the board of the army
  def pieces(army)
    @squares.flatten.select { |piece| !piece.nil? && piece.color == army }
  end

  # Повертає позицію у масиві +squares+ для заданої координати
  # @param coordinate [String] координата на дошці, напр. 'a1'
  # @return [Array] масив [рядок, стовпець] або піднімає InvalidCoordinateError якщо координата некоректна
  # @raise [InvalidCoordinateError] коли координата не належить дошці
  def parse_coordinate(coordinate)
    if coordinate.length == 2
      file = coordinate[0].ord - 97
      rank = coordinate[1].to_i - 1
      return [rank, file] if rank.between?(0, squares.length) && file.between?(0, squares[0].length)
    end
    raise InvalidCoordinateError
  end

  # Повертає фігуру на заданій +coordinate+
  # @param coordinate [String]
  # @return [Piece, nil] фігура на полі або nil
  # @raise [InvalidCoordinateError] коли координата некоректна
  def get_piece_at(coordinate)
    rank, file = parse_coordinate(coordinate)
    squares[rank][file]
  end

  # Повертає координату поля, на якому знаходиться переданий +piece+
  # @param piece [Piece]
  # @return [String, nil] координата фігури або nil
  def get_coordinate(piece)
    coordinate = nil
    @squares.each_with_index do |rank, rank_index|
      rank.each_with_index do |file, file_index|
        coordinate = (97 + file_index).chr + (rank_index + 1).to_s if file.eql? piece
      end
    end
    coordinate
  end

  private

  # Внутрішній метод для #blocked_path? — повертає наступну клітинку в заданому
  # +direction+
  def next_square(current_square, direction)
    rank, file = parse_coordinate(current_square)

    next_rank = rank + direction[0]
    next_file = file + direction[1]

    "#{(next_file + 97).chr}#{next_rank + 1}"
  end

  # Повертає позначення доступних рокіровок у позиції для FEN нотації
  # Перевіряє лише чи король/вежа ще не рухалися — не перевіряє легальність самої рокіровки
  # FEN відображає лише наявність права на рокіровку
  def available_castles
    available_castles = ''
    # For white
    king = get_piece_at('e1')

    if king.is_a?(King) && king.color == 'white' && !king.moved
      # Kingside
      rook = get_piece_at('h1')
      available_castles += 'K' if rook.is_a?(Rook) && rook.color == 'white' && !rook.moved
      # Queenside
      rook = get_piece_at('a1')
      available_castles += 'Q' if rook.is_a?(Rook) && rook.color == 'white' && !rook.moved
    end

    # For black
    king = get_piece_at('e8')
    if king.is_a?(King) && king.color == 'black' && !king.moved
      # Kingside
      rook = get_piece_at('h8')
      available_castles += 'k' if rook.is_a?(Rook) && rook.color == 'black' && !rook.moved
      # Queenside
      rook = get_piece_at('a8')
      available_castles += 'q' if rook.is_a?(Rook) && rook.color == 'black' && !rook.moved
    end

    available_castles.empty? ? '-' : available_castles
  end
end
