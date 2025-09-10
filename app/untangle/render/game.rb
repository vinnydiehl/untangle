class UntangleGame
  def render_game_init
    @outputs[:line].w = 1
    @outputs[:line].h = 1
    @outputs[:line].primitives << {
      primitive_marker: :solid,
      x: 0, y: 0, w: 1, h: 1,
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
    @edges.each do |p1, p2|
      @primitives << thick_line(p1.x, p1.y, p2.x, p2.y)
    end
  end

  def render_nodes
    @nodes.each do |node|
      @primitives << {
        x: node.x - NODE_RADIUS, y: node.y - NODE_RADIUS,
        w: NODE_DIAMETER, h: NODE_DIAMETER,
        path: "sprites/node.png",
      }
    end
  end

  def thick_line(x1, y1, x2, y2, thickness: LINE_THICKNESS)
    dx = x2 - x1
    dy = y2 - y1
    length = Math.sqrt((dx * dx) + (dy * dy))
    angle = Math.atan2(dy, dx) * 180 / Math::PI

    {
      x: x1, y: y1,
      w: length, h: thickness,
      angle: angle,
      angle_anchor_x: 0, angle_anchor_y: 0,
      path: :line,
    }
  end
end
