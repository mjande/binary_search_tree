class Node
  attr_accessor :left_child, :right_child
  attr_reader :data
  
  include Comparable

  def initialize(value)
    p "New node: #{value} created."
    @data = value 
    @left_child = nil
    @right_child = nil
  end
end