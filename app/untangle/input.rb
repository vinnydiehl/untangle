class UntangleGame
  def handle_mouse_inputs
    if @mouse.key_down?(:left)
      @node_held = node_under_mouse
    end

    if @mouse.key_held?(:left)
      move_node(@node_held, @mouse.x, @mouse.y)
    end

    if @mouse.key_up?(:left)
      @node_held = nil
    end
  end

  # Returns the index of the node under the mouse, or nil if the mouse
  # isn't over a node.
  def node_under_mouse
    @nodes.find_index { |node| @mouse.intersect_rect?(node_rect(node)) }
  end
end
