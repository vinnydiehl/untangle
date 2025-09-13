class UntangleGame
  def selection_rect
    {
      x: [@selection_box_origin.x, @mouse.x].min,
      y: [@selection_box_origin.y, @mouse.y].min,
      w: (@selection_box_origin.x - @mouse.x).abs,
      h: (@selection_box_origin.y - @mouse.y).abs,
    }
  end

  def select_nodes(node_indices)
    clear_selection
    node_indices.each { |i| add_selection(i) }
  end

  def add_selection(i)
    @selection << i
    @selection_orig_pos[i] = @nodes[i]
  end

  def remove_selection(i)
    @selection.delete(i)
    @selection_orig_pos.delete(i)
  end

  def clear_selection
    @selection = []
    @selection_orig_pos = {}
  end
end
