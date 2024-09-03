require_relative "node"

# this class will be used to make tree Object
class Tree
  attr_accessor :root

  def initialize(array)
    # sort the array and remove duplicates
    @array = array.sort.uniq
    @root = nil
  end

  def build_tree(start_index = 0, end_index = @array.length)
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
end
