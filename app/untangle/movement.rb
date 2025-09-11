class UntangleGame
  # Moves the node at index `i` to the coordinates at `x` and `y`.
  def move_node(i, x, y)
    @nodes[i] = [x, y]
  end
end
