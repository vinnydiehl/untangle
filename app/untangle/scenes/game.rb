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
  end

  def game_tick; end
end
