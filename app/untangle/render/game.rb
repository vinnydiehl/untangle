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
    @outputs[:line_held].w = 1
    @outputs[:line_held].h = 1
    @outputs[:line_held].primitives << {
      primitive_marker: :solid,
      x: 0, y: 0, w: 1, h: 1,
      r: 30, g: 30, b: 30,
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
    time = @timer_end ? @timer_end : @timer

    @primitives << {
      x: 0 + TEXT_PADDING,
      y: @screen_height - TEXT_PADDING,
      text: format_time(
        # Don't start timer until start animation is over
        [0, (time - START_ANIMATION_DURATION)].max
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
    @edges.each { |e| render_edge(e, :line) }

    # Render edges connected to the @node_held in a lighter color
    if @node_held
      edges_connected_to(@node_held).each { |e| render_edge(e, :line_held) }
    end

    # Hold `i` to highlight intersecting edges red
    if @kb.key_held?(:i)
      intersecting_edges.each { |e| render_edge(e, :line_red) }
    end
  end

  def render_edge((i, j), path)
    p1 = @nodes[i]
    p2 = @nodes[j]

    @primitives << thick_line(p1[0], p1[1], p2[0], p2[1], path: path)
  end

  def edges_connected_to(i)
    @edges.select { |e| e.include?(i) }
  end

  def render_nodes
    connected = @node_held ? connected_nodes(@node_held) : []
    @nodes.each_with_index do |node, i|
      filename = "node"

      if @game_solved
        filename = "node_solved"
      end

      if @node_held && connected.include?(i)
        filename = "node_connected"
      end

      @primitives << {
        **node_rect(node),
        path: "sprites/#{filename}.png",
      }
    end

    # Render held node above the others
    if @node_held
      @primitives << {
        **node_rect(@nodes[@node_held]),
        path: "sprites/node_selected.png",
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
