class UntangleGame
  def render_game_init
    @outputs[:line].w = 1
    @outputs[:line].h = 1
    @outputs[:line].primitives << {
      primitive_marker: :solid,
      x: 0, y: 0, w: 1, h: 1,
    }
    @outputs[:line_red].w = 1
    @outputs[:line_red].h = 1
    @outputs[:line_red].primitives << {
      primitive_marker: :solid,
      x: 0, y: 0, w: 1, h: 1,
      r: 255, g: 0, b: 0,
    }
  end

  def render_game
    render_background
    render_timer
    render_edges
    render_nodes

    if @game_solved
      render_solved_message
      # Render timer again so it's on top of the nodes/edges
      render_timer
    end
  end

  def render_timer
    @primitives << {
      x: 0 + TEXT_PADDING,
      y: @screen_height - TEXT_PADDING,
      text: format_time(
        # Don't start timer until start animation is over
        [0, ((@timer_end || @ticks - @timer_start) - START_ANIMATION_DURATION)].max
      ),
      size_enum: TIMER_SIZE,
      r: 255, g: 255, b: 255,
    }
  end

  def render_solved_message
    @primitives << {
      x: @screen_width - TEXT_PADDING,
      y: TEXT_PADDING,
      text: "Click anywhere to go to main menu.",
      size_enum: SOLVED_MESSAGE_SIZE,
      alignment_enum: 2,
      vertical_alignment_enum: 0,
      r: 255, g: 255, b: 255,
    }
  end

  def format_time(ticks)
    minutes, seconds = (ticks / 60).divmod(60)
    minutes.zero? ? format("%.2f", seconds) :
                    format("%d:%05.2f", minutes, seconds)
  end

  def render_edges
    crossed = intersecting_edges

    @edges.each do |i, j|
      p1 = @nodes[i]
      p2 = @nodes[j]

      # Make intersecting edges red if the I key is held
      path = crossed.include?([i, j]) && @kb.key_held?(:i) ? :line_red : :line

      @primitives << thick_line(p1[0], p1[1], p2[0], p2[1], path: path)
    end
  end

  def render_nodes
    connected = @node_held ? connected_nodes(@node_held) : []
    @nodes.each_with_index do |node, i|
      filename = "node"

      if @game_solved
        filename = "node_solved"
      end

      if @node_held
        if @node_held == i
          filename = "node_selected"
        elsif connected.include?(i)
          filename = "node_connected"
        end
      end

      @primitives << {
        **node_rect(node),
        path: "sprites/#{filename}.png",
      }
    end
  end

  def node_rect(node)
    x, y = node

    {
      x: x - NODE_RADIUS, y: y - NODE_RADIUS,
      w: NODE_DIAMETER, h: NODE_DIAMETER,
    }
  end

  # Returns a list of node indices that are connected to the node
  # at index `i`
  def connected_nodes(i)
    @edges.each_with_object([]) do |(u, v), list|
      list << v if u == i
      list << u if v == i
    end
  end

  def thick_line(x1, y1, x2, y2, thickness: LINE_THICKNESS, path: :line)
    dx = x2 - x1
    dy = y2 - y1
    length = Math.sqrt((dx * dx) + (dy * dy))
    angle = Math.atan2(dy, dx) * 180 / Math::PI

    {
      x: x1, y: y1,
      w: length, h: thickness,
      angle: angle,
      angle_anchor_x: 0, angle_anchor_y: 0,
      path: path,
    }
  end
end
