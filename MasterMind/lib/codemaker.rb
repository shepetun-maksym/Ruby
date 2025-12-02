require_relative 'constants'

class Codemaker
  include Constants
  attr_reader :code

  def initialize
    @code = []
  end

  def check_guess(guess)
    key_pegs = { red: 0, white: 0 }
    code_copy = @code.dup

    guess.each_with_index do |el, idx|
      if code_copy[idx] == el
        key_pegs[:red] += 1
        code_copy[idx] = nil
        guess[idx] = ''
      end
    end

    guess.each do |el|
      if code_copy.include?(el)
        key_pegs[:white] += 1
        code_copy[code_copy.index(el)] = nil
      end
    end
    key_pegs
  end
end

class ComputerCodemaker < Codemaker
  def set_code
    @code = 4.times.map { COLORS.keys.shuffle.sample.to_s }
  end
end

class PlayerCodemaker < Codemaker
  def set_code
    puts 'Доступні кольори: червоний, зелений, синій, жовтий, бірюзовий, фіолетовий.'
    puts 'Введи секретний код (без лапок) у форматі "color color color color": '
    loop do
      @code = gets.chomp
      break if /^(#{PATTERN}\s){3}#{PATTERN}$/.match(@code)
      puts 'Неправильний ввід. Спробуй ще раз:'
    end
    @code = @code.split(' ')
  end
end