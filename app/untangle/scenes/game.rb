class UntangleGame
  def game_init
    generate_nodes_and_edges

    render_game_init
  end

  def generate_nodes_and_edges
    # We're gonna use somthing like this later to rearrange the nodes
    # into a neat circle
    #
    # cx = @screen_width / 2
    # cy = @screen_height / 2
    #
    # # Make a circle of nodes centered in the screen
    # @nodes = (0...NODE_COUNT).map do |i|
    #   angle = (2 * Math::PI * i / NODE_COUNT)
    #   r = 250 # radius
    #   [cx + Math.cos(angle) * r, cy + Math.sin(angle) * r]
    # end

    # Randomly place the nodes all over the screen
    @nodes = []
    until @nodes.size >= NODE_COUNT
      @nodes << loop do
        x = rand(@screen_width)
        y = rand(@screen_height)
        # Keep iterating until we find a spot a reasonable distance away from
        # other nodes. This prevents the solution from being too pixel-perfect
        if @nodes.all? { |nx, ny| Math.hypot(nx - x, ny - y) >= NODE_DIAMETER }
          break [x, y]
        end
      end
    end

    @edges = []

    @edges = [[@nodes.sample, @nodes.sample], [@nodes.sample, @nodes.sample]]
  end

  # Takes 2 edges and returns whether or not they intersect.
  def intersect?(e1, e2)
    x1, y1 = e1
    x2, y2 = e2

    # If they share a node, not considered intersecting
    return false if [x1, y1].any? { |pt| [x2, y2].include?(pt) }

    # Orientation tests
    o1 = orientation(x1, y1, x2)
    o2 = orientation(x1, y1, y2)
    o3 = orientation(x2, y2, x1)
    o4 = orientation(x2, y2, y1)

    # General case
    return true if o1 != o2 && o3 != o4

    # Special cases (collinear + overlap)
    return on_segment?(x1, x2, y1) if o1 == 0
    return on_segment?(x1, y2, y1) if o2 == 0
    return on_segment?(x2, x1, y2) if o3 == 0
    return on_segment?(x2, y1, y2) if o4 == 0

    false
  end

  def orientation(x, y, r)
    val = (y[1] - x[1]) * (r[0] - y[0]) -
          (y[0] - x[0]) * (r[1] - y[1])

    # Collinear
    return 0 if val.abs < 1e-9
    # 1 = clockwise, 2 = counter-clockwise
    val > 0 ? 1 : 2
  end

  def on_segment?(x, y, r)
    y[0].between?([x[0], r[0]].min, [x[0], r[0]].max) &&
    y[1].between?([x[1], r[1]].min, [x[1], r[1]].max)
  end

  def intersecting_edges
    @edges.combination(2).select { |e1, e2| intersect?(e1, e2) }.flatten(1).uniq
  end

  def game_tick; end
end
