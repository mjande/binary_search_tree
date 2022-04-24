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
      node = Node.new(array[mid])
      # binding.pry
      node.left_child = build_tree(array, start, mid - 1)
      node.right_child = build_tree(array, mid + 1, array_end)
    end
    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    # binding.pry
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

# [1, 3, 4, 5, 7, 8, 9, 23, 67, 324, 6345]