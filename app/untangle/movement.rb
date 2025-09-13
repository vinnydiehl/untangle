class UntangleGame
  # Moves the node at index `i` to the coordinates at `x` and `y`.
  def move_node(i, x, y, nodes: @nodes)
    nodes[i] = [x, y]
  end

  # Begin an animated node move. Eases the node towards the `target_coords`.
  def animate_move_node(i, target_coords, duration)
    @animated_nodes << [@ticks, duration, i, @nodes[i], target_coords]
            p '----------'
    p @animated_nodes
  end

  def run_animation
    return unless @animated_nodes.any?

    @animated_nodes.select! do |start, duration, i, (sx, sy), (tx, ty)|
      progress = start.ease(duration, :cube)

      x = sx + (tx - sx) * progress
      y = sy + (ty - sy) * progress
      move_node(i, x, y)

      progress < 1
    end
  end
end
