# main.rb

require_relative 'lib/knight'

# Using the refactored `Horse` class (functionally identical to Knight)
horse = Horse.new

puts 'Enter start coordinates (x y):'
start = STDIN.gets&.chomp.to_s.split.map(&:to_i)

puts 'Enter finish coordinates (x y):'
finish = STDIN.gets&.chomp.to_s.split.map(&:to_i)

if start.empty? || finish.empty?
	puts 'Invalid input. Please provide two integers for start and finish.'
else
	horse.shortest_path(start, finish)
end
