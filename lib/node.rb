class Node
  attr_accessor :left_child, :right_child, :data
  
  include Comparable

  def initialize(value = nil)
    @data = value 
    @left_child = nil
    @right_child = nil
  end
end