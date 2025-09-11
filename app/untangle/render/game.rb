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

    @outputs[:background].w = @screen_width
    @outputs[:background].h = @screen_height
    @outputs[:background].primitives << {
      primitive_marker: :solid,
      x: 0, y: 0,
      w: @screen_width, h: @screen_height,
      r: 63, g: 63, b: 63,
    }
  end

  def render_game
    render_background
    render_edges
    render_nodes
  end

  def render_background
    @primitives << {
      x: 0, y: 0,
      w: @screen_width, h: @screen_height,
      path: :background,
    }
  end

  def render_edges
    crossed = intersecting_edges
    @edges.each do |i, j|
      p1 = @nodes[i]
      p2 = @nodes[j]
      # For debug: make intersecting edges red
      path = crossed.include?([i, j]) ? :line_red : :line
      @primitives << thick_line(p1[0], p1[1], p2[0], p2[1], path: path)
    end
  end

  def render_nodes
    @nodes.each do |node|
      @primitives << {
        **node_rect(node),
        path: "sprites/node.png",
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
