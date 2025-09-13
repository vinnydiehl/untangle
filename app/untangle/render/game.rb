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
    @outputs[:line_selected].w = 1
    @outputs[:line_selected].h = 1
    @outputs[:line_selected].primitives << {
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

    if @selection.any?
      render_connected_nodes
      render_selected_edges
      render_selected_nodes
    end

    if @selection_box_origin
      render_selection_box
    end

    if @game_solved
      render_solved_message
      # Render timer again so it's on top of the nodes/edges
      # when in the solved state
      render_timer
    end
  end

  def render_timer
    time = @timer_end ? @timer_end : actual_time(@timer)

    @primitives << {
      x: 0 + TEXT_PADDING,
      y: @screen_height - TEXT_PADDING,
      text: format_time([0, time].max),
      size_enum: TIMER_SIZE,
      r: 255, g: 255, b: 255,
    }

    # Time to beat
    if @time_to_beat
      @primitives << {
        x: 0 + TEXT_PADDING,
        y: @screen_height - TEXT_PADDING - 50,
        text: "(#{format_time(@time_to_beat)})",
        size_enum: TIME_TO_BEAT_SIZE,
        r: 255, g: 255, b: 255,
      }
    end

    # "New best time" message
    if @new_best_time
      @primitives << {
        x: @screen_width - TEXT_PADDING,
        y: @screen_height - TEXT_PADDING,
        text: "New best time for #{@difficulty.to_capitalized_str} mode!",
        size_enum: NEW_BEST_TIME_MESSAGE_SIZE,
        alignment_enum: 2,
        r: 255, g: 255, b: 255,
      }
    end
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
    @edges.each { |e| render_edge(e) }

    # Hold `i` to highlight intersecting edges red
    if @highlight_intersecting_edges
      intersecting_edges.each { |e| render_edge(e, path: :line_red) }
    end
  end

  # Render edges connected to the selected nodes in a lighter color
  def render_selected_edges
    @selection.each do |i|
      edges_connected_to(i).each { |e| render_edge(e, path: :line_selected) }
    end
  end

  def render_edge((i, j), path: :line)
    @primitives << thick_line(*edge_line(i, j), path: path)
  end

  def edges_connected_to(i)
    @edges.select { |e| e.include?(i) }
  end

  def render_nodes
    @nodes.each_with_index do |node, i|
      filename = "node"
      filename += "_solved" if @game_solved

      @primitives << {
        **node_rect(node),
        path: "sprites/#{filename}.png",
      }
    end
  end

  def render_connected_nodes
    @selection.each do |i|
      connected_nodes(i).each do |ci|
        @primitives << {
          **node_rect(@nodes[ci]),
          path: "sprites/node_connected.png",
        }
      end
    end
  end

  def render_selected_nodes
    @selection.each do |i|
      @primitives << {
        **node_rect(@nodes[i]),
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

  # Takes node indices `i` and `j` and returns an array containing
  # the `[x1, y1, x2, y2]` of the line that needs to be drawn for
  # that edge.
  #
  # Because some edges are drawn on top of the nodes (i.e. edges
  # connected to a selection), we need to clip the ends of the line
  # so that they meet the node at the edge, rather than stabbing
  # through the center.
  def edge_line(i, j)
    x1, y1 = @nodes[i]
    x2, y2 = @nodes[j]

    dx = x2 - x1
    dy = y2 - y1
    length = Math.sqrt((dx * dx) + (dy * dy))

    # Length might be zero if a selected node is right over one of
    # the connected nodes. Dividing by zero doesn't crash DragonRuby,
    # it just returns Infinity, but that's still not what we want
    return [x1, y1, x2, y2] if length.zero?

    # Normalize direction
    ux = dx / length
    uy = dy / length

    # Move endpoints inward by radius
    [
      x1 + ux * NODE_RADIUS, y1 + uy * NODE_RADIUS,
      x2 - ux * NODE_RADIUS, y2 - uy * NODE_RADIUS
    ]
  end

  def render_selection_box
    @primitives << {
      primitive_marker: :border,
      **selection_rect,
      **SELECTION_BOX_COLOR,
    }
  end
end
