require_relative 'tree'

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 23, 9, 67, 6345, 324])
tree.pretty_print

p tree.height(tree.find(8))