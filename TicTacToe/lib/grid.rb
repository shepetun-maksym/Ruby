class Grid
  EMPTY_CELL = '-'
  SIZE = 3

  def initialize
    @cells = create_empty_grid
  end

  def place_mark(symbol, position)
    row, col = position
    return false unless valid_placement?(row, col)
    @cells[row][col] = symbol
    true
  end

  def get_all_lines
    horizontal_lines + vertical_lines + diagonal_lines
  end

  def has_winner?
    get_all_lines.each do |line|
      return line.first if winning_line?(line)
    end
    nil
  end

  def cell_empty?(row, col)
    @cells[row][col] == EMPTY_CELL
  end

  def to_s
    result = ""
    @cells.each do |row|
      result += "+---" * SIZE + "+\n"
      result += "| #{row.join(' | ')} |\n"
    end
    result += "+---" * SIZE + "+\n"
    result
  end

  private

  def create_empty_grid
    Array.new(SIZE) { Array.new(SIZE, EMPTY_CELL) }
  end

  def valid_placement?(row, col)
    row.between?(0, SIZE - 1) && col.between?(0, SIZE - 1) && cell_empty?(row, col)
  end

  def horizontal_lines
    @cells
  end

  def vertical_lines
    @cells.transpose
  end

  def diagonal_lines
    [
      (0...SIZE).map { |i| @cells[i][i] },
      (0...SIZE).map { |i| @cells[i][SIZE - 1 - i] }
    ]
  end

  def winning_line?(line)
    line.uniq.size == 1 && line.first != EMPTY_CELL
  end
end