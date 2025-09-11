class UntangleGame
  def generate_game
    generate_nodes
    generate_edges
  end

  # Randomly place the nodes all over the screen.
  def generate_nodes
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
  end

  # Generate @edges. This is a list of index pairs of @nodes. For
  # example, if @nodes[0] is connected to @nodes[1], @edges will
  # contain [0, 1] or [1, 0].
  def generate_edges
    n = @nodes.size
    # Array of how many edges are connected to each node (by index)
    degrees = Array.new(n, 0)
    @edges = []

    # Compute convex hull and connect hull edges first to ensure a
    # fully connected border around all nodes.
    hull = convex_hull_indices
    hull.each_with_index do |i, idx|
      # Modulo so it wraps around at the end
      j = hull[(idx + 1) % hull.size]
      add_edge(i, j, degrees)
    end

    # Build minimum spanning tree for nodes inside the hull, connecting
    # them to the hull via nodes the shortest distance away.
    # This isn't strictly necessary but creates a more sensible geometry.
    in_mst = Array.new(n, false)
    hull.each { |i| in_mst[i] = true }
    remaining = (0...n).to_a.reject { |i| in_mst[i] }
    until remaining.empty?
      # Find the nearest node not in the tree
      i, j = in_mst.each_index
                   .select { |i| in_mst[i] }
                   .product(remaining)
                   .min_by { |i, j| dist2(@nodes[i], @nodes[j]) }

      add_edge(i, j, degrees)
      in_mst[j] = true
      remaining.delete(j)
    end

    # Generate greedy edges up to MAX_DEGREE
    loop do
      added = false

      # Sort vertices by current degree so low-degree nodes are prioritized
      (0...n).sort_by { |i| degrees[i] }.each do |j|
        # Skip nodes that have reached the maximum degree
        next if degrees[j] >= MAX_DEGREE

        # Find candidate neighbors that are eligible for an edge and
        # sort them by distance.
        # This excludes the current node, nodes at max degree, or existing edges
        candidates = (0...n).reject do |k|
          k == j || degrees[k] >= MAX_DEGREE || edge_exists?(j, k)
        end.sort_by { |k| dist2(@nodes[j], @nodes[k]) }

        candidates.each do |k|
          # Skip if adding this edge would intersect any existing edge
          next if @edges.any? { |u, v| intersect?([j, k], [u, v]) }

          # Skip if this edge would pass through another node
          next if @nodes.each_with_index.any? do |pt, idx|
            idx != j && idx != k && point_on_segment?(pt, @nodes[j], @nodes[k])
          end

          # Add the edge and update the degree counters
          add_edge(j, k, degrees)
          added = true
          break
        end

        # Break out of the vertex loop if an edge has been added this iteration
        break if added
      end

      # Stop the loop when no more edges can be added
      break unless added
    end
  end

  # Adds an edge to @edges. Takes a reference to an Array `degrees` which
  # it updates the relevant indices of.
  def add_edge(i, j, degrees)
    @edges << [i, j]
    degrees[i] += 1
    degrees[j] += 1
  end

  # Returns an ordered array of the node indices that need to be connected
  # to form a convex hull around all of the nodes.
  def convex_hull_indices
    # Prepare an array of nodes with their original indices, sorted
    # y-coordinate, breaking ties by x-coordinate
    pts = @nodes.map.with_index { |p, i| [p[0], p[1], i] }
                .sort_by { |x, y, _| [y, x] }

    # Choose the pivot point, we'll make it the bottom-most
    # (and left-most if tied)
    pivot = pts.first

    # Sort the remaining points by the angle they make with the pivot
    sorted = pts[1..].sort_by { |x, y, _| Math.atan2(y - pivot[1], x - pivot[0]) }

    # Initialize the convex hull with the pivot
    hull = [pivot]

    # Iterate over each sorted point to build the convex hull
    sorted.each do |pt|
      # Remove the last point from the hull if it would create a non-left turn
      # This prevents undesired concavity
      while hull.size >= 2 && cross2d(hull[-2], hull[-1], pt) <= 0
        hull.pop
      end

      hull << pt
    end

    # Return the original indices of the points forming the convex hull
    hull.map { |p| p[2] }
  end

  # Computes the 2D cross product of vectors AB and AC.
  # Returns a positive value if ABC makes a counter-clockwise turn,
  # a negative value if it makes a clockwise turn, and zero if the
  # points are collinear.
  def cross2d(a, b, c)
    (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])
  end

  # Calculates the squared distance between 2 nodes; this is more efficient
  # than calculating Euclidean distance.
  def dist2(a, b)
    dx, dy = a[0] - b[0], a[1] - b[1]
    dx * dx + dy * dy
  end

  # Returns whether or not there is an edge connecting nodes `a` and `b`.
  def edge_exists?(a, b)
    @edges.include?([a, b]) || @edges.include?([b, a])
  end

  # Takes 2 edges and returns whether or not they intersect.
  def intersect?(e1, e2)
    i1, j1 = e1
    i2, j2 = e2

    p1, q1 = @nodes[i1], @nodes[j1]
    p2, q2 = @nodes[i2], @nodes[j2]

    # If they share a node, not considered intersecting
    return false if [i1, j1].any? { |idx| [i2, j2].include?(idx) }

    # Orientation tests
    o1 = orientation(p1, q1, p2)
    o2 = orientation(p1, q1, q2)
    o3 = orientation(p2, q2, p1)
    o4 = orientation(p2, q2, q1)

    # General case
    return true if o1 != o2 && o3 != o4

    # If 2 collinear lines overlap perfectly, they do not intersect
    return on_segment?(p1, p2, q1) if o1 == 0
    return on_segment?(p1, q2, q1) if o2 == 0
    return on_segment?(p2, p1, q2) if o3 == 0
    return on_segment?(p2, q1, q2) if o4 == 0

    false
  end

  # Determines the orientation of an ordered triplet of points (p, q, r).
  #
  # The orientation can be:
  #   0 → Collinear (all three points lie on a straight line)
  #   1 → Clockwise
  #   2 → Counterclockwise
  def orientation(p, q, r)
    val = (q[1] - p[1]) * (r[0] - q[0]) -
          (q[0] - p[0]) * (r[1] - q[1])

    # Collinear
    return 0 if val.abs < 1e-9
    # 1 = clockwise, 2 = counterclockwise
    val > 0 ? 1 : 2
  end

  # Determines whether the point `q` lies on the line segment defined by points
  # `p` and `r`. This function **assumes that `q` is already collinear** with
  # `p` and `r`.
  def on_segment?(p, q, r)
    q[0].between?([p[0], r[0]].min, [p[0], r[0]].max) &&
    q[1].between?([p[1], r[1]].min, [p[1], r[1]].max)
  end

  # Determines whether the point `p` lies on the line segment defined by points
  # `a` and `b`. This function performs a **full check**, including collinearity
  # and bounding box containment.
  def point_on_segment?(p, a, b)
    cross = (p[1] - a[1]) * (b[0] - a[0]) - (p[0] - a[0]) * (b[1] - a[1])
    return false unless cross.abs < 1e-6

    (p[0] - a[0]) * (p[0] - b[0]) <= 0 && (p[1] - a[1]) * (p[1] - b[1]) <= 0
  end

  # Returns an array of all edges which intersect another edge.
  def intersecting_edges
    @edges.combination(2).select { |e1, e2| intersect?(e1, e2) }.flatten(1).uniq
  end
end
