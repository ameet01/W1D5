class KnightPathFinder
  POSSIBLE_MOVES = [
    [1,2],
    [1,-2],
    [2,1],
    [2,-1],
    [-1,2],
    [-1,-2],
    [-2,1],
    [-2,-1],
  ]
  attr_accessor :path

  def initialize(pos)
    @start_position = pos
    @visited_positions = [@start_position]
    @board = Array.new(8) { Array.new(8) }
    @path = []
  end

  def self.valid_moves(pos)
    result = []

    POSSIBLE_MOVES.each do |move|
      array = pos.dup
      array[0] += move[0]
      array[1] += move[1]
      if (0..7).to_a.include?(array[0]) && (0..7).to_a.include?(array[1])
        result << array
      end
    end

    result
  end

  def new_move_positions(pos)
    arr = KnightPathFinder.valid_moves(pos)
    arr.reject! { |position| @visited_positions.include?(position) }
    @visited_positions.concat(arr)
    arr
  end

  def build_move_tree
    queue = [PolyTreeNode.new(@start_position)]
    until queue.empty?
      current_node = queue.shift
      arr = new_move_positions(current_node.value)
      arr.each do |val|
        node = PolyTreeNode.new(val)
        current_node.add_child(node)
        queue << node
      end

      @path << current_node
    end
  end

  # @path.each do |node|
  #   p "value: #{node.value}, children: #{node.children.map {|i| i.value}}"
  # end
end



class PolyTreeNode
  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent
    @parent
  end

  def parent=(node)
    old_parent = @parent unless @parent.nil?

    @parent = node
    if node && node.value && !@parent.children.include?(self)
      node.children << self
      old_parent.children.delete(self) unless old_parent.nil?
    end

  end

  def children
    @children
  end

  def add_child(child_node)
    @children << child_node
    child_node.parent = self
  end

  def remove_child(child_node)
    raise "Not a node" if !@children.include?(child_node)
    @children.delete(child_node)
    child_node.parent = nil
  end

  def value
    @value
  end

  def dfs(target_value)
    return self if target_value == @value
    @children.each do |child|
      result = child.dfs(target_value)
      return result if result
    end
    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.value == target_value
      current_node.children.each do |child|
        queue << child
      end
    end
    nil
  end

end
