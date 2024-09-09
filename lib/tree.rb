require_relative "node"

# this class will be used to make tree Object
class Tree
  attr_accessor :root

  def initialize(array)
    # sort the array and remove duplicates
    @array = array.sort.uniq
    @root = nil
  end

  def build_tree(start_index = 0, end_index = @array.length - 1)
    return nil if start_index > end_index

    mid = (start_index + end_index) / 2
    root = Node.new(@array[mid])
    root.left = build_tree(start_index, mid - 1)
    root.right = build_tree(mid + 1, end_index)

    root
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(number, node = @root)
    return Node.new(number) if node.nil?

    if number < node.data
      node.left = insert(number, node.left)
    elsif number > node.data
      node.right = insert(number, node.right)
    end
    node
  end

  def delete(node, value)
    return null if node.nil?

    if value < node.data
      node.left = delete(node.left, value)
      node
    elsif value > node.data
      node.right = delete(node.right, value)
      node
    elsif value == node.data
      if node.left.nil?
        node.right
      elsif node.right.nil?
        node.left

      else
        node.right = lift(node.right, node)
        node
      end
    end
  end

  def lift(node, node_to_delete)
    if node.left
      node.left = lift(node.left, node_to_delete)
      node
    else
      node_to_delete.data = node.data
      node.right
    end
  end

  def find(node, value)
    return if node.nil?

    if value < node.data
      find(node.left, value)
    elsif value > node.data
      find(node.right, value)
    else
      node
    end
  end

  # def level_order(node, array = [node], return_array = [] ,&block)
  #   return if array.empty?

  #   block_given? ? yield(node) : return_array.push(node.data)
  #   array.push(node.left) if node.left
  #   array.push(node.right) if node.right
  #   array.shift
  #   level_order(array[0], array, return_array, &block)
  #   return return_array unless block_given?
  # end

  def level_order(node = @root, &block)
    return_array = []
    queue = [node]
    current_node = node
    until queue.empty?
      current_node = queue.shift
      block_given? ? yield(current_node) : return_array.push(current_node.data)
      queue.push(current_node.left) if current_node.left
      queue.push(current_node.right) if current_node.right
    end
    return_array unless block_given?
  end

  def inorder(node = @root, array = [], &block)
    return if node.nil?

    inorder(node.left, array, &block)
    block_given? ? yield(node) : array.push(node.data)
    inorder(node.right, array, &block)
    array unless block_given?
  end

  def pre_order(node = @root, array = [], &block)
    return if node.nil?

    block_given? ? yield(node) : array.push(node.data)
    pre_order(node.left, array, &block)
    pre_order(node.right, array, &block)
    array unless block_given?
  end

  def post_order(node = @root, array = [], &block)
    return if node.nil?

    post_order(node.left, array, &block)
    post_order(node.right, array, &block)
    block_given? ? yield(node) : array.push(node.data)
    array unless block_given?
  end

  def height(node = root)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    left_height < right_height ? right_height + 1 : left_height + 1
  end

  def depth(node, root = @root)
    return -1 if root.nil?

    depth = -1
    return depth + 1 if node == root

    depth = depth(node, root.left)
    return depth + 1 if depth >= 0

    depth = depth(node, root.right)
    depth + 1 if depth >= 0
  end

  def balanced?(root = @root)
    return true if root.nil?

    difference_in_height = height(root.left) - height(root.right)
    return false if difference_in_height.abs > 1

    balanced?(root.left) && balanced?(root.right)
  end

  def rebalance
    sorted_array = inorder
    tree = Tree.new(sorted_array)
    self.root = tree.build_tree
  end
end
