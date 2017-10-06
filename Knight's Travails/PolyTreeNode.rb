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
