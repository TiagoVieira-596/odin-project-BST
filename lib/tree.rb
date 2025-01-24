require_relative 'node'
require 'pry-byebug'
class Tree
  attr_accessor :root

  def initialize(array)
    sorted_array = array.sort.uniq
    @root = build_tree(sorted_array)
  end

  def build_tree(sorted_array, start_position = 0, end_position = sorted_array.length - 1)
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
    until (node.left.nil? && node.right.nil?) || node.left.nil? && value <= node.data || node.right.nil? && value > node.data
      node = node.compare(node, value) ? node.left : node.right
    end
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

  def height(node)
    return -1 if node.nil?

    height = 0
    tree = @root
    # get the height of the left and right subtrees
    height_left = height(node.left)
    height_right = height(node.right)
    # assign the highest value to be the current height
    height = height_left >= height_right ? height_left + 1 : height_right + 1
    height
  end

  def depth(node)
    return -1 if node.nil?

    depth = 0
    tree = @root
    until tree.nil?
      break if tree.data == node.data

      tree = tree.compare(tree, node.data) ? tree.left : tree.right
      depth += 1
    end
    depth
  end

  def balanced?(root)
    return true if root.nil?

    balanced = true
    height_left = height(root.left)
    height_right = height(root.right)
    balanced = false if height_left - height_right > 1 || height_right - height_left > 1
    balanced
  end

  def rebalance(root)
    tree_data_array = inorder(root)
    @root = nil
    @root = build_tree(tree_data_array.sort)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
