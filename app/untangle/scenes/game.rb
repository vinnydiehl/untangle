class UntangleGame
  def game_init
    # Index of node held by the mouse
    @node_held = nil

    generate_game
    render_game_init
  end

  def game_tick
    handle_mouse_inputs
  end
end
