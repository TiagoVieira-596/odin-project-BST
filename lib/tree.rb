require_relative 'node'
require 'pry-byebug'
class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array, 0, array.length - 1)
  end

  def build_tree(sorted_array, start_position, end_position)
    return nil if start_position > end_position

    middle = start_position + ((end_position - start_position) / 2).floor
    root_node = Node.new(sorted_array[middle])
    root_node.left = build_tree(sorted_array, start_position, middle - 1)
    root_node.right = build_tree(sorted_array, middle + 1, end_position)

    root_node
  end

  def insert(value)
    # traverse into the correct leaf node
    node = @root
    node = node.compare(node, value) ? node.left : node.right until node.left.nil? && node.right.nil?
    # append value
    node.compare(node, value) ? node.left = Node.new(value) : node.right = Node.new(value)
  end

  def remove(root, value)
    node = root
    # base case: return if the current node is empty
    return node if node.nil?

    # recursively traverse the tree to find the value
    if node.data > value
      node.left = remove(node.left, value)
    elsif node.data < value
      node.right = remove(node.right, value)
    else
      # removing the node if it has only 1 or no child node
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      # when it has both children: recursively find the values to substitute the previous node's values
      temp_node = node
      temp_node = temp_node.right
      temp_node = temp_node.left while temp_node.nil? && temp_node.left.nil?
      node.data = temp_node.data
      node.right = remove(node.right, temp_node.data)
    end
    node
  end

  def find(value)
    node = @root
    until node.nil?
      return node if node.data == value

      node = node.compare(node, value) ? node.left : node.right
    end
    nil
  end

  def level_order(root)
    return if root.nil?

    data_array = []
    queue = []
    queue.push(root)
    until queue.empty?
      node = queue[0]
      yield node.data if block_given?
      data_array << node.data
      queue.push(node.left) unless node.left.nil?
      queue.push(node.right) unless node.right.nil?
      queue.delete_at(0)
    end
    data_array unless block_given?
  end

  def inorder(root, &block)
    return if root.nil?

    if block_given?
      inorder(root.left, &block)
      yield root.data
      inorder(root.right, &block)
    else
      data_array = []
      inorder(root) { |node_data| data_array << node_data }
      data_array
    end
  end

  def preorder(root, &block)
    return if root.nil?

    if block_given?
      yield root.data
      preorder(root.left, &block)
      preorder(root.right, &block)
    else
      data_array = []
      preorder(root) { |node_data| data_array << node_data }
      data_array
    end
  end

  def postorder(root, &block)
    return if root.nil?

    if block_given?
      postorder(root.left, &block)
      postorder(root.right, &block)
      yield root.data
    else
      data_array = []
      postorder(root) { |node_data| data_array << node_data }
      data_array
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
