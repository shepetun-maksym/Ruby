
require_relative 'lib/hash_map'
require_relative 'lib/hash_set'


puts "Testing HashMap"
hash_map = HashMap.new

hash_map.set('apple', 'red')
hash_map.set('banana', 'yellow')
hash_map.set('carrot', 'orange')
hash_map.set('dog', 'brown')

puts "Get 'apple': #{hash_map.get('apple')}"
puts "Has 'banana'? #{hash_map.has?('banana')}"
puts "Remove 'carrot': #{hash_map.remove('carrot')}"
puts "Keys: #{hash_map.keys}"
puts "Values: #{hash_map.values}"
puts "Length: #{hash_map.length}"
hash_map.clear
puts "Length after clear: #{hash_map.length}" # 0

puts "\nTesting HashSet"
hash_set = HashSet.new

hash_set.add('apple')
hash_set.add('banana')
hash_set.add('carrot')
hash_set.add('dog')

puts "Has 'banana'? #{hash_set.has?('banana')}"
puts "Has 'frog'? #{hash_set.has?('frog')}"
puts "Remove 'banana': #{hash_set.remove('banana')}"
puts "Has 'banana'? #{hash_set.has?('banana')}"
puts "Keys: #{hash_set.keys}"
puts "Length: #{hash_set.length}"
hash_set.clear
puts "Length after clear: #{hash_set.length}"