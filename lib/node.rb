module Comparable
  def compare(node, value)
    # returns true if the value should go left and false if right
    node.data >= value
  end
end

class Node
  include Comparable

  attr_accessor :left, :right, :data

  def initialize(data = nil)
    @left = nil
    @right = nil
    @data = data
  end
end
