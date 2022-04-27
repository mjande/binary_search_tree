require_relative 'tree'

# Driver Script to test
tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
p tree.balanced?

p tree.level_order_iter
p tree.pre_order
p tree.post_order
p tree.in_order

# Unbalance the tree
tree.insert(rand(100..150))
tree.insert(rand(100..150))
tree.insert(rand(100..150))
tree.insert(rand(100..150))
tree.pretty_print
p tree.balanced?

tree.rebalance
tree.pretty_print

p tree.balanced?
p tree.level_order_iter
p tree.pre_order
p tree.post_order
p tree.in_order
