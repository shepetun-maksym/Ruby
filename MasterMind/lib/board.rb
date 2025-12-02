class Board
  COLORS = {
    red: "\e[31m",
    blue: "\e[34m",
    green: "\e[32m",
    yellow: "\e[33m",
    cyan: "\e[36m",
    purple: "\e[35m",
    white: "\e[0m"
  }.freeze

  attr_reader :board, :row_pointer, :code_cracked, :players_role

  ROWS = 12
  COLUMNS = 5

  def initialize
    @board = Array.new(ROWS) { Array.new(COLUMNS) { |col| col < COLUMNS - 1 ? '●' : Array.new(4, ' ') } }
    @row_pointer = 11
    @code_cracked = false
    @players_role = ''
  end

  def print_board
    puts '_______________________'
    @board.each do |row|
      row.each_with_index do |el, idx|
        print(idx < row.length - 1 ? "| #{el} " : "| #{el[0]} #{el[1]} |\n________________|_#{el[2]}_#{el[3]}_|\n")
      end
      puts '_______________________'
    end
  end

  def insert_guess(guess)
    guess.split(' ').each_with_index do |color, c|
      @board[@row_pointer][c] = "#{COLORS[color.to_sym]}#{@board[@row_pointer][c]}#{COLORS[:white]}"
    end
  end

  def insert_key_pegs(key_pegs)
    idx = 0
    key_pegs.each { |key, val| val.times { @board[@row_pointer][4][idx] = "#{COLORS[key]}o#{COLORS[:white]}"; idx += 1 } }
    @row_pointer -= 1
  end

  def check_red_key_pegs
    @code_cracked = @board[@row_pointer + 1][4].all? { |el| el == "#{COLORS[:red]}o#{COLORS[:white]}" }
  end

  def set_players_role
    puts 'Бажаєш грати як Кодмейкер чи Кодкрейкер?'
    puts 'Введи "Codemaker" або "Codecracker": '
    loop do
      @players_role = gets.chomp
      break if /^(codecracker|codemaker)$/i.match(@players_role.downcase)
      puts 'Неправильний ввід, спробуй ще раз: '
    end
    @players_role
  end
end