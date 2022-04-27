require_relative 'node'
require 'pry-byebug'

class Tree
  attr_reader :root, :array
  
  def initialize(array)
    array = merge_sort(array).uniq
    @array = array
    @root = build_tree(array, 0, array.length - 1)
  end

  def merge_sort(array)
    n = array.length
    if n < 2
      return array
    else
      array_b = merge_sort(array.slice(0..(n - 1) / 2))
      index_b = 0
      array_c = merge_sort(array.slice(((n - 1) / 2 + 1)..-1))
      index_c = 0
      sorted_array = []
  
      until array_b.empty? || array_c.empty?
        if array_b[index_b] < array_c[index_c]
          sorted_array.push(array_b.shift)
        else 
          sorted_array.push(array_c.shift) 
        end
      end
  
      if array_b.empty?
        array_c.each { |el| sorted_array.push(el) }
      elsif array_c.empty?
        array_b.each { |el| sorted_array.push(el) }
      end
      sorted_array
    end
  end
    
  def build_tree(array, start, array_end)
    if start > array_end
      nil
    else
      mid = (start + array_end) / 2
      node = Node.new
      node.left_child = build_tree(array, start, mid - 1)
      node.data = array[mid] 
      node.right_child = build_tree(array, mid + 1, array_end)
    end
    node
  end

  def insert(value)
    node = @root
    until node.nil?
      if value < node.data
        if node.left_child.nil?
          node.left_child = Node.new(value) 
          break
        else
          node = node.left_child
        end
      elsif value > node.data
        if node.right_child.nil?
          node.right_child = Node.new(value)
        else
          node = node.right_child
        end
      else
        puts "A node with that value already exists in the tree."
        break
      end
    end
  end

  # Recursively search for given value (starting at root).
  # Once found, check if there are any children
    # If there is one or no children, send child or nil up the call stack to update
      # children of parent nodes
  # If there are two children, search for next highest value (leftmost value of 
    # right branch), insert 
  def delete(node = @root, value)
    p "Searching through Node: #{node.data}."
    if value < node.data
      node.left_child = delete(node.left_child, value)
    elsif value > node.data
      node.right_child = delete(node.right_child, value)
      node
    else
      if node.left_child.nil? || node.right_child.nil?
        return node.left_child if node.right_child.nil?
        return node.right_child if node.left_child.nil?

        nil
      else
        # Find left-most descendant of right child (next highest value)
        original_node = node
        node = node.right_child
        prev = node
        until node.left_child.nil?
          prev = node
          node = node.left_child
        end
        # Update children
        prev.right_child = node.right_child
        prev.left_child = nil
        node.left_child = original_node.left_child
        unless original_node.right_child == node
          node.right_child = original_node.right_child
        end
        node
      end
    end
  end

  def find(value)
    node = @root
    until value == node.data
      if value > node.data
        node = node.right_child
      else
        node = node.left_child
      end
    end
    node
  end

  def level_order_iter(&block)
    return @array unless block_given?
    return if @root.nil?

    queue = []
    return_array = []
    queue.push(@root)
    until queue.empty?
      node = queue[0]
      return_array.push(block.call(node))
      queue.push(node.left_child) unless node.left_child.nil?
      queue.push(node.right_child) unless node.right_child.nil?
      queue.shift
    end
    return_array
  end


  # Come back to this?
  def level_order_rec(node = @root, queue = [], &block)
    return if node.nil?

    queue.push(node) if node == @root

    puts block.call(queue[0])
    queue.push(node.left_child) unless node.left_child.nil?
    queue.push(node.right_child) unless node.right_child.nil?
    level_order_rec(node.left_child, queue, &block)
    level_order_rec(node.right_child, queue, &block)
  end

  def in_order(node = @root, &block)
    return @array unless block_given?

    return_array = []
    return if node.nil?

    return_array << in_order(node.left_child, &block) unless node.left_child.nil?
    return_array << block.call(node)
    return_array << in_order(node.right_child, &block) unless node.right_child.nil?
    return_array.flatten
  end

  def pre_order(node = @root, &block)
    return @array unless block_given?
    return if node.nil?

    return_array = []
    return_array << block.call(node)
    return_array << pre_order(node.left_child, &block) unless node.left_child.nil?
    return_array << pre_order(node.right_child, &block) unless node.right_child.nil?
    return_array.flatten
  end

  def post_order(node = @root, &block)
    return @array unless block_given?
    return if node.nil?

    return_array = []
    return_array << post_order(node.left_child, &block) unless node.left_child.nil?
    return_array << post_order(node.right_child, &block) unless node.right_child.nil?
    return_array << block.call(node)
    return_array.flatten
  end

  def height(node)
    left_path_height =
      if node.left_child.nil?
        -1
      else
        height(node.left_child)
      end
    right_path_height =
      if node.right_child.nil?
        -1
      else
        height(node.right_child)
      end
    if left_path_height > right_path_height
      left_path_height + 1
    else
      right_path_height + 1
    end
  end

  def depth(node)
    return height(@root) if node == @root

    current_node = @root
    depth = 0
    loop do
      if node.data < current_node.data
        current_node = current_node.left_child
        depth += 1
      elsif node.data > current_node.data
        current_node = current_node.right_child
        depth += 1
      else
        return depth
      end
    end
  end


  # Method copied from TOP Discord
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

# [1, 3, 4, 5, 7, 8, 9, 23, 67, 324, 6345]