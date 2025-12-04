require_relative 'board'

class Match
  def initialize
    @grid = Board.new
    @turn = :X
  end

  # Expose the board (keeps compatibility for callers that inspect it)
  def board
    @grid
  end

  # Render the current board to the console
  def show_board
    puts '-' * 13
    @grid.board_array.each do |row|
      puts "| #{row.join(' | ')} |"
      puts '-' * 13
    end
  end

  # Game loop
  def run
    until over?
      move = ask_move
      if @grid.make_play(turn, *move)
        # clear the terminal if possible (Windows/Unix may differ)
        system('clear') || system('cls')
        show_board
      else
        puts "Неправильний хід."
        puts "Спробуй ще, #{turn}"
      end
      toggle_turn
    end
  end

  # Ask user for their move and parse into integers
  def ask_move
    print "Введи свій хiд (ряд колонка): "
    STDIN.gets.to_s.split.map(&:to_i)
  end

  # Check for a winning line
  def over?
    victor = @grid.check_victory
    if victor
      puts "#{victor} Перемiг!"
      true
    else
      false
    end
  end

  # Current turn symbol
  def turn
    @turn
  end

  # Swap active player
  def toggle_turn
    @turn = (@turn == :X ? :O : :X)
  end
end