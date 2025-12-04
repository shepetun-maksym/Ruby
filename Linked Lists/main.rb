require_relative 'lib/LinkedList.rb'

# Use the refactored SinglyLinked list API
list = SinglyLinked.new

list.push_back('dog')
list.push_back('cat')
list.push_back('parrot')
list.push_back('hamster')
list.push_back('snake')
list.push_back('turtle')

puts list
