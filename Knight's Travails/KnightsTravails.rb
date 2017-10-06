require_relative 'PolyTreeNode'

class KnightPathFinder
  POSSIBLE_MOVES = [
    [1, 2],
    [1, -2],
    [2, 1],
    [2, -1],
    [-1, 2],
    [-1, -2],
    [-2, 1],
    [-2, -1],
  ]

  def initialize(pos)
    @start_position = pos
    @root_node = PolyTreeNode.new(@start_position)
    @visited_positions = [@start_position]
    @move_tree = []
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
    arr = KnightPathFinder.valid_moves(pos).shuffle
    arr.reject! { |position| @visited_positions.include?(position) }
    @visited_positions.concat(arr)
    arr
  end

  def build_move_tree
    queue = [ @root_node ]
    until queue.empty?
      current_node = queue.shift
      arr = new_move_positions(current_node.value)

      arr.each do |val|
        node = PolyTreeNode.new(val)
        current_node.add_child(node)
        queue << node
      end
    end
  end

  def find_path_dfs(end_pos)
    last_node = @root_node.dfs(end_pos)
    trace_path_back(last_node)
  end

  def find_path_bfs(end_pos)
    last_node = @root_node.bfs(end_pos)
    trace_path_back(last_node)
  end

  def trace_path_back(last_node)
    node = last_node
    result = [node.value]
    until node.parent == nil
      result << node.parent.value
      node = node.parent
    end
    result.reverse
  end

end

if __FILE__ == $PROGRAM_NAME
  knight = KnightPathFinder.new([0, 0])
  knight.build_move_tree
  p knight.find_path_bfs([6, 2])
  p knight.find_path_dfs([6, 2])
end
