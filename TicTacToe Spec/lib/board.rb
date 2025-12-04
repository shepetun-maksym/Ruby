class Board
  def initialize
    @board_array = Array.new(3) { Array.new(3, ' ') }
  end

  def board_array
    @board_array
  end

  def make_play(player, row, col)
    if blank?(@board_array[row][col])
      @board_array[row][col] = player.to_s
      true
    else
      false
    end
  end

  def lines
    rows = @board_array
    cols = @board_array.transpose
    diags = [
      [@board_array[0][0], @board_array[1][1], @board_array[2][2]],
      [@board_array[0][2], @board_array[1][1], @board_array[2][0]]
    ]
    rows + cols + diags
  end

  def check_victory
    lines.each do |line|
      return "X" if line.all? { |cell| cell == "X" }
      return "O" if line.all? { |cell| cell == "O" }
    end
    nil
  end

  def blank?(cell)
    cell == ' '
  end
end