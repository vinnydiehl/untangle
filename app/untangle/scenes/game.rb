class UntangleGame
  def game_init
    @game_solved = false

    # Index and original position of node held by the mouse
    @node_held = nil
    @node_orig_pos = nil

    generate_game
    render_game_init
  end

  def game_tick
    handle_mouse_inputs
  end
end
