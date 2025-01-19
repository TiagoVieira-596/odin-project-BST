require_relative 'tree'
test = Tree.new([1, 2, 3, 4, 5, 6, 7].sort.uniq)
p test.find(2)
test.pretty_print
