require_relative "grid"

class Match
  PLAYERS = ['X', 'O']

  def initialize
    @grid = Grid.new
    @current_player_index = 0
  end

  def start
    show_grid
    game_loop
  end

  private

  def game_loop
    loop do
      coordinates = ask_for_move
      
      if execute_move(coordinates)
        clear_screen
        show_grid
        break if game_over?
        next_player
      else
        puts "Ця клітинка зайнята або координати неправильні!"
        puts "#{active_player}, спробуй ще раз."
      end
    end
  end

  def ask_for_move
    print "#{active_player}, введи координати (рядок стовпець): "
    input = gets.chomp.split
    input.map(&:to_i)
  end

  def execute_move(coordinates)
    @grid.place_mark(active_player, coordinates)
  end

  def game_over?
    champion = @grid.has_winner?
    if champion
      puts "Гравець #{champion} виграв!"
      return true
    end
    false
  end

  def active_player
    PLAYERS[@current_player_index]
  end

  def next_player
    @current_player_index = (@current_player_index + 1) % PLAYERS.size
  end

  def show_grid
    puts @grid.to_s
  end

  def clear_screen
    system('clear') || system('cls')
  end
end