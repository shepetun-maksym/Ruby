require_relative 'lib/node'
require_relative 'lib/tree'

tree = BinarySearchTree.new(Array.new(15) { rand(1..100) })

puts tree.balanced?
tree.pretty_print
print "\nLevel Order: #{tree.level_order}"
print "\nPre order: #{tree.preorder}"
print "\nPost order: #{tree.postorder}"
print "\nIn order: #{tree.inorder}\n"

tree.insert(107)
tree.insert(6348)
tree.insert(579)
tree.insert(825)

tree.pretty_print
puts tree.balanced?

tree.rebalance
puts tree.balanced?
tree.pretty_print
print "\nLevel Order: #{tree.level_order}"
print "\nPre order: #{tree.preorder}"
print "\nPost order: #{tree.postorder}"
print "\nIn order: #{tree.inorder}\n"