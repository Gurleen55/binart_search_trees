require "rubocop"
require_relative "lib/node"
require_relative "lib/tree"

tree = Tree.new((Array.new(15) { rand(1..100) }))
tree.root = tree.build_tree

puts "level order0"
p tree.level_order
puts "pre order"
p tree.pre_order
puts "post order"
p tree.post_order
puts "inorder"
p tree.inorder
tree.insert(102)
tree.insert(101)
tree.insert(106)
p tree.balanced?
tree.rebalance
p tree.balanced?
