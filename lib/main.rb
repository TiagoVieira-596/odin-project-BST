require_relative 'tree'
test = Tree.new((Array.new(15) { rand(1..100) }))

test.pretty_print
p test.balanced?(test.root)

test.insert(101)
test.insert(600)
test.insert(596)
test.insert(599)
test.insert(1000)

test.pretty_print

p test.balanced?(test.root)
test.rebalance(test.root)
p test.balanced?(test.root)

test.pretty_print
