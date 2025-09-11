class UntangleGame
  def handle_mouse_inputs
    # Don't allow mouse input if we're running an animation
    return if @animated_nodes.any?

    if @mouse.key_down?(:left) && (@node_held = node_under_mouse)
      @node_orig_pos = @nodes[@node_held]
    end

    if @node_held
      if @mouse.key_held?(:left)
        move_node(@node_held, @mouse.x, @mouse.y)
      end

      if @mouse.key_up?(:left)
        # Check if we dragged the node off the screen
        if !@mouse.intersect_rect?([0, 0, @screen_width, @screen_height])
          animate_move_node(@node_held, @node_orig_pos, RETURN_ANIMATION_DURATION)
        else
          @game_solved = intersecting_edges.empty?
        end

        @node_held = nil
        @node_orig_pos = nil
      end
    end
  end

  # Returns the index of the node under the mouse, or nil if the mouse
  # isn't over a node.
  def node_under_mouse
    @nodes.find_index { |node| @mouse.intersect_rect?(node_rect(node)) }
  end
end
